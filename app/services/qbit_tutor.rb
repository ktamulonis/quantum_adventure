require "json"
require "net/http"

class QbitTutor
  MODEL = ENV.fetch("OLLAMA_MODEL", "llama3.2:latest").freeze
  ENDPOINT = ENV.fetch("OLLAMA_URL", "http://127.0.0.1:11434/api/chat").freeze
  MAX_QUESTION_LENGTH = 1_000

  class UnavailableError < StandardError; end

  COURSE_CONTEXT = {
    "qubit-basics" => <<~CONTEXT,
      Mission 1: Qubit Basics. The learner can prepare |0>, |1> by applying X to |0>,
      or |+> by applying H to |0>. The simulator shows amplitudes, a Bloch vector,
      and exact measurement probabilities in Z, X, and Y bases. Explain that selecting
      Prepare |0> runs no gate, Prepare |1> runs X, and Prepare |+> runs H. Explain
      probabilities directly: |0> is certain to return 0 in Z, |1> is certain to return
      1 in Z. |+> has amplitudes 1/√2 for |0> and 1/√2 for |1>, a Bloch vector
      of approximately { x: 1, y: 0, z: 0 }, 50/50 Z-basis probabilities, and
      certainty for + in the X basis.
    CONTEXT
    "superposition" => <<~CONTEXT,
      Mission 2: Superposition. H prepares |+>; H followed by Z prepares |->; H followed
      by S prepares |+i>. Help the learner distinguish amplitudes, phases, probabilities,
      and measurement basis. A relative phase can affect a later interference experiment
      even when Z-basis probabilities match.
    CONTEXT
    "entanglement" => <<~CONTEXT,
      Mission 3: Entanglement. H on q0 followed by CX q0→q1 prepares the phi-plus Bell
      state. Its ideal computational-basis outcomes are 00 and 11, and its concurrence is 1.
      Explain correlated outcomes without claiming either person can signal faster than light.
    CONTEXT
    "bell-test" => <<~CONTEXT,
      Mission 4: Bell Test. The lesson runs four genuine circuit-based CHSH measurement
      settings. The classical limit is 2 and the quantum maximum is 2√2. Explain that a
      violation rules out local-hidden-variable models under the experiment assumptions;
      it does not enable faster-than-light messaging.
    CONTEXT
    "teleportation" => <<~CONTEXT,
      Mission 5: Quantum Teleportation. The learner follows a real three-qubit statevector
      protocol. Qubit 0 is Alice's input state. Alice and Bob first make a Bell pair with
      qubits 1 and 2. Alice applies CX from q0 to q1 and H to q0, then measures q0 and q1.
      Those actual measurement bits are sent by an ordinary classical channel to Bob. Bob
      applies X when Alice's q1 bit is 1 and Z when Alice's q0 bit is 1. His final qubit
      matches the input up to global phase. Explain that no matter travels, the input is not
      cloned, Alice's original state is consumed by measurement, and classical communication
      prevents faster-than-light messaging.
    CONTEXT
    "interference" => <<~CONTEXT,
      Mission 6: Interference. The learner can run three one-qubit QuantumRB circuits with
      exact state snapshots: H then H reinforces |0>; H then Z then H uses a relative phase
      to cancel |0> and reinforce |1>; H then Z is |->, which remains 50/50 in an immediate
      Z measurement even though the |1> amplitude has a minus sign. Explain that amplitudes
      combine before probabilities are measured. A final H can make a relative phase visible.
      This is the basic constructive/destructive interference idea behind quantum algorithms;
      it is not a guarantee of a correct answer or a faster-than-light effect.
    CONTEXT
    "grovers-search" => <<~CONTEXT
      Mission 7: Grover's Search. This is the smallest exact example: two qubits encode
      four candidates (00, 01, 10, 11), and the learner chooses one marked state. H on both
      qubits creates equal amplitudes. The oracle uses X gates around CZ as necessary to
      flip only the marked state's phase; it does not reveal the answer. The diffusion
      sequence H-H-X-X-CZ-X-X-H-H converts that phase marking into constructive interference
      on the target and destructive interference on the other three states. In this ideal
      four-item case, one Grover iteration gives the marked outcome with certainty. Explain
      that useful speedup is meaningful for larger unstructured spaces only when a quantum
      oracle for the condition can be implemented; arbitrary databases are not automatically searchable.
    CONTEXT,
    "noise-hardware" => <<~CONTEXT
      Mission 8: Noise & Real Hardware. The learner compares ideal QuantumRB statevector sampling with an explicit local, seeded Pauli X/Z error channel. The clean H-H circuit returns |0> with certainty. The bit-flip demonstration samples an X error after an identity step, so some |0> runs become |1>. The phase-flip demonstration samples Z between two H gates, making some runs end at |1> because the final H converts relative phase into a measurable result. Be clear that this is an educational error model, not IBM hardware, not a model of every real-device error, and not a live hardware result.
    CONTEXT,
    "error-correction" => <<~CONTEXT
      Mission 9: Error Correction. The learner uses QuantumRB's real five-qubit statevector trace for a three-data-qubit repetition code plus two syndrome ancillas. The code encodes |0> as |000> and |1> as |111>; superpositions are joint codewords, not independent clones. The lesson injects at most one actual X error on q0, q1, or q2. Parity syndromes are 11 for q0, 10 for q1, 01 for q2, and 00 for no error. The syndrome selects a real X correction, restoring the input logical state with fidelity 1 in the ideal simulator. Explain carefully that the two ancillas reveal error parity, not the unknown logical value. This toy code corrects one bit flip only, not phase flips, multiple errors, or all real-hardware noise.
    CONTEXT,
    "shors-factoring" => <<~CONTEXT
      Mission 10: Shor's Factoring. This is a deliberately tiny, honest QuantumRB period-finding example that factors 15 with base 2. Four counting qubits enter equal superposition; a controlled modular-multiplication permutation writes 2^x mod 15 into a four-qubit work register. An inverse QFT creates counting-register peaks at 0000, 0100, 1000, and 1100, which correspond to the period 4. A genuine seeded measurement may first produce the unhelpful 0000 sample, so the protocol can retry. Classical gcd arithmetic then turns r = 4 into 3 and 5. Explain that Shor's algorithm finds period information rather than reading factors directly, this lesson is not useful large-number factoring, and real practical factoring would require much larger fault-tolerant hardware and modular arithmetic circuits. Do not claim that arbitrary databases become searchable or that this app breaks encryption.
    CONTEXT
  }.freeze

  def self.reply(mission:, question:, history: [], transport: Net::HTTP)
    question = normalize_question(question)
    uri = URI(ENDPOINT)
    request = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
    request.body = JSON.generate(model: MODEL, stream: false,
                                 messages: messages_for(mission: mission, question: question, history: history),
                                 options: { temperature: 0.3, num_predict: 700 })

    http = transport.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    http.open_timeout = 2
    http.read_timeout = 30
    response = http.start do |client|
      client.request(request)
    end
    raise UnavailableError, "Q-Bit's local model is unavailable" unless response.is_a?(Net::HTTPSuccess)

    extract_reply(JSON.parse(response.body).dig("message", "content"))
  rescue Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout, SocketError, JSON::ParserError => error
    raise UnavailableError, "Q-Bit is unavailable: #{error.message}"
  end

  def self.system_prompt_for(mission)
    context = COURSE_CONTEXT.fetch(mission.slug) { "This mission is not ready for tutoring yet." }
    <<~PROMPT
      You are Q-Bit, the friendly robot guide in Quantum Adventure, an educational Rails app backed by a pure-Ruby quantum statevector simulator.
      Answer the learner's question using the current mission context below. Be accurate, concrete, warm, and concise (normally two short paragraphs or less). Explain notation and the simulator controls when useful. Do not fabricate an experiment result. Do not claim real quantum hardware, cryptographic security, or faster-than-light communication. Do not reveal hidden chain-of-thought; provide a clear teaching explanation instead.

      #{context}
    PROMPT
  end

  def self.messages_for(mission:, question:, history: [])
    [ { role: "system", content: system_prompt_for(mission) } ] + normalize_history(history) + [ { role: "user", content: question } ]
  end

  def self.normalize_question(question)
    value = question.to_s.strip
    raise ArgumentError, "Ask Q-Bit a question first." if value.empty?
    raise ArgumentError, "Keep questions under #{MAX_QUESTION_LENGTH} characters." if value.length > MAX_QUESTION_LENGTH

    value
  end
  private_class_method :normalize_question

  def self.normalize_history(history)
    Array(history).last(6).filter_map do |entry|
      entry = entry.to_h.stringify_keys
      next unless %w[user assistant].include?(entry["role"])

      content = entry["content"].to_s.strip
      next if content.empty? || content.length > MAX_QUESTION_LENGTH

      { role: entry["role"], content: content }
    end
  end
  private_class_method :normalize_history

  def self.extract_reply(content)
    reply = content.to_s.split("</think>", 2).last.to_s.strip
    raise UnavailableError, "Q-Bit returned no teaching reply" if reply.blank?

    reply
  end
  private_class_method :extract_reply
end
