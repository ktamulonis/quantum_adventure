# frozen_string_literal: true

# Concise historical context and simulator-connected clues for Quantum Adventure.
# Stories are intentionally short so the experiment remains the centre of each mission.
class MissionLearningContent
  STORIES = {
    "qubit-basics" => {
      heading: "The qubit gave quantum information a compact name",
      body: "Physicists had studied quantized systems for decades, but Benjamin Schumacher’s 1995 work on quantum coding gave the field the compact word “qubit.” A qubit is not a tiny classical bit: it is a quantum state that can be prepared and measured in different bases.",
      named_for: "“Qubit” is short for “quantum bit.”"
    },
    "superposition" => {
      heading: "Superposition comes from the wave rule",
      body: "Quantum mechanics describes states with wave-like amplitudes. Because the equations are linear, valid states can be combined into superpositions. The Hadamard gate in this lesson is a modern circuit tool for creating and comparing those combinations.",
      named_for: "The Hadamard gate is named for French mathematician Jacques Hadamard, whose matrix is used in its definition."
    },
    "entanglement" => {
      heading: "Entanglement was named in a 1935 argument",
      body: "Einstein, Podolsky, and Rosen used a thought experiment to question whether quantum mechanics was complete. Erwin Schrödinger responded in 1935 and called the unusual linked states “entanglement.” Today, that once-puzzling feature is a resource for quantum information.",
      named_for: "“Entanglement” describes a joint state that cannot be split into independent states for its parts."
    },
    "bell-test" => {
      heading: "Bell turned a philosophical dispute into a test",
      body: "In 1964, Northern Irish physicist John Bell derived an inequality that local hidden-variable theories must obey. The later CHSH version made a practical experiment clearer, and experiments by John Clauser, Alain Aspect, Anton Zeilinger, and many others tested the prediction.",
      named_for: "Bell inequalities are named for John Bell. CHSH names John Clauser, Michael Horne, Abner Shimony, and Richard Holt."
    },
    "teleportation" => {
      heading: "Teleportation was proposed as state transfer",
      body: "In 1993, Charles Bennett, Gilles Brassard, Claude Crépeau, Richard Jozsa, Asher Peres, and William Wootters described how entanglement plus two classical bits can transfer an unknown quantum state. The name is a metaphor: no object or matter travels from Alice to Bob.",
      named_for: "The protocol is called teleportation because the state is reconstructed elsewhere, not because a particle is transported."
    },
    "interference" => {
      heading: "Quantum computing borrows a lesson from waves",
      body: "Long before quantum mechanics, Thomas Young’s double-slit experiment showed that waves can reinforce and cancel. Quantum experiments revealed the same amplitude rule for microscopic systems. Quantum algorithms use this wave-like bookkeeping to steer probabilities before measurement.",
      named_for: "Interference is the name for waves adding constructively or destructively."
    },
    "grovers-search" => {
      heading: "Lov Grover found a search rule based on phase",
      body: "In 1996, Lov Grover presented a quantum algorithm for unstructured search. Its key idea is not to read every answer at once: a phase-marking oracle and diffusion step make the desired amplitude reinforce over repeated iterations.",
      named_for: "Grover’s search is named for Lov K. Grover."
    },
    "noise-hardware" => {
      heading: "Real quantum hardware must fight its environment",
      body: "A simulator can preserve an ideal state forever, but physical qubits interact with their surroundings. That interaction causes noise and decoherence, turning delicate phase relationships into engineering constraints. This mission will compare the clean model with that practical challenge.",
      named_for: "Decoherence means the loss of usable quantum coherence through interaction with an environment."
    },
    "error-correction" => {
      heading: "Error correction was a surprising breakthrough",
      body: "It once seemed impossible to protect unknown quantum states because measuring them can disturb them. In 1995, Peter Shor showed that several physical qubits can encode one logical qubit so certain errors can be detected and corrected without reading the protected state directly.",
      named_for: "The first nine-qubit code is named for Peter Shor."
    },
    "shors-factoring" => {
      heading: "A period-finding idea changed the conversation",
      body: "In the mid-1990s, Peter Shor showed that a sufficiently capable quantum computer could factor integers by turning the task into a period-finding problem. The result mattered because factoring underpins some classical cryptographic systems, but this lesson will use only small, understandable examples.",
      named_for: "Shor’s algorithm is named for Peter Shor."
    }
  }.freeze

  CLUES = {
    "qubit-basics" => {
      "zero" => {
        title: "A measurement has probabilities, not hidden answers",
        body: "The Z card shows 0 at 100% for |0⟩. Those percentages are probabilities: they tell you the chance of each possible measurement outcome."
      },
      "one" => {
        title: "The X gate is the quantum bit flip",
        body: "This preparation starts at |0⟩ and applies X. The state becomes |1⟩, so a Z measurement returns 1 with certainty."
      },
      "plus" => {
        title: "A qubit can be predictable in one basis and random in another",
        body: "H prepares |+⟩. It looks 50/50 in the Z basis, but the X card shows + at 100%. The state is not a classical coin flip."
      }
    },
    "superposition" => {
      "plus" => {
        title: "H prepares an X-basis state",
        body: "H turns |0⟩ into |+⟩. The equal Z-basis probabilities do not mean the qubit has secretly chosen a classical value."
      },
      "minus" => {
        title: "A minus sign is a relative phase",
        body: "|−⟩ has the same immediate Z-basis probabilities as |+⟩, but its |1⟩ amplitude has the opposite phase. A later gate can reveal that difference."
      },
      "plus_i" => {
        title: "Phase has more than plus and minus",
        body: "The S gate changes the |1⟩ amplitude by i. The Y-basis result is where that phase becomes directly predictable."
      }
    },
    "entanglement" => {
      "bell_pair" => {
        title: "The pair is a joint state",
        body: "H on q0 and CX to q1 creates phi-plus. The individual outcomes are random, but the pair’s outcomes are correlated: 00 and 11."
      },
      "concurrence" => {
        title: "Concurrence measures two-qubit entanglement",
        body: "A concurrence of 1 means this pure two-qubit Bell state is maximally entangled. A separable state would have concurrence 0."
      },
      "no_signal" => {
        title: "Correlation is not a message",
        body: "Alice cannot choose her random result to send Bob a controllable signal. The correlation appears only when their outcomes are later compared."
      }
    },
    "bell-test" => {
      "classical_limit" => {
        title: "Bell’s limit is a bound, not a score",
        body: "In the CHSH setup, local hidden-variable models cannot exceed |S| = 2. The experiment asks whether measured correlations cross that bound."
      },
      "four_settings" => {
        title: "One setting is not enough",
        body: "CHSH combines four measurement-setting pairs. Comparing all four is what makes the classical bound meaningful."
      },
      "meaning" => {
        title: "A violation still cannot signal faster than light",
        body: "Bell violations challenge local-hidden-variable explanations under the test assumptions. They do not let either experimenter choose the other side’s random outcome."
      }
    },
    "teleportation" => {
      "bell_pair" => {
        title: "Entanglement is the shared resource",
        body: "Alice and Bob create a Bell pair before the input state is measured. Without that shared resource, Bob has no quantum state that can receive the protocol’s correction."
      },
      "measurements" => {
        title: "Alice’s measurement consumes the independent input",
        body: "Alice gets two ordinary bits from real measurements. The original input is no longer available as a second independent copy, so teleportation does not clone it."
      },
      "corrections" => {
        title: "Bob must wait for two ordinary bits",
        body: "Bob applies X and/or Z based on Alice’s measured bits. The classical message is why teleportation cannot send information faster than light."
      }
    },
    "interference" => {
      "reinforce_zero" => {
        title: "In-phase paths reinforce",
        body: "H then H returns to |0⟩ because the two amplitude paths recombine constructively there and cancel at |1⟩."
      },
      "cancel_zero" => {
        title: "A phase flip redirects the outcome",
        body: "H then Z then H changes the relative phase before recombination. The paths now cancel at |0⟩ and reinforce at |1⟩."
      },
      "hidden_phase" => {
        title: "Probability alone can hide phase",
        body: "H then Z still looks 50/50 in an immediate Z measurement. The phase is real information because another H can convert it into a different probability pattern."
      }
    },
    "grovers-search" => {
      "00" => {
        title: "Superposition gives every candidate a starting chance",
        body: "After the first two H gates, all four candidates have equal amplitude and 25% probability. Grover does not know the answer yet."
      },
      "01" => {
        title: "The oracle marks with phase, not a reveal",
        body: "The phase oracle flips only the selected candidate’s amplitude sign. Its probability stays 25%, so no answer has been read out at this stage."
      },
      "10" => {
        title: "Diffusion turns phase into probability",
        body: "The diffusion circuit recombines amplitudes around their average. In this four-item case, the marked amplitude reinforces to certainty after one iteration."
      },
      "11" => {
        title: "The speedup needs a usable oracle",
        body: "For larger search spaces Grover can reduce oracle calls quadratically, but someone must still build a quantum oracle that recognizes a solution."
      }
    },
    "noise-hardware" => {
      "clean" => {
        title: "A simulator starts with an ideal reference",
        body: "The clean statevector run preserves every amplitude exactly, so H then H returns |0⟩ in every shot. It shows the mathematical target—not a guarantee that a physical device behaves perfectly."
      },
      "bit_flip" => {
        title: "A bit flip changes a measurement value",
        body: "The sampled X channel sometimes turns |0⟩ into |1⟩. Each shot samples independently, so the observed fraction is close to, not necessarily exactly, the configured chance."
      },
      "phase_flip" => {
        title: "A phase flip can spoil a later interference test",
        body: "Z changes relative phase. Between two H gates, that phase change is converted into a different final Z outcome. That is why keeping phase coherent matters for quantum algorithms."
      }
    },
    "error-correction" => {
      "none" => {
        title: "The no-error reference checks the codeword",
        body: "With syndrome 00, the encoded state needs no physical correction. The redundancy has not measured the protected logical value."
      },
      "0" => {
        title: "A syndrome locates an error without reading the message",
        body: "The parity checks return 11 when q0 flips. They reveal which physical qubit disagrees with the other two, not whether the logical state was |0⟩ or |1⟩."
      },
      "1" => {
        title: "Correction is a conditional physical gate",
        body: "For syndrome 10, the protocol applies X to q1. The recovery is an actual statevector gate selected from the measured syndrome."
      },
      "2" => {
        title: "This code has a clear limit",
        body: "Syndrome 01 points to q2 for one bit flip. A phase flip or more than one error can fool this simple code, which is why real error correction needs richer codes."
      }
    }
  }.freeze

  def self.story_for(slug)
    STORIES.fetch(slug)
  end

  def self.clues_for(slug)
    CLUES.fetch(slug, {})
  end
end
