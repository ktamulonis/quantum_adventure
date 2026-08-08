# frozen_string_literal: true

# Concise historical context and simulator-connected clues for Quantum Adventure.
# Stories are intentionally short so the experiment remains the centre of each mission.
class MissionLearningContent
  STORIES = {
    "qubit-basics" => {
      heading: "1995: a new kind of information gets a name",
      body: "Imagine a 1990s computer lab: beige monitors, floppy disks, and bits that can only be 0 or 1. Physicists already knew tiny quantum objects follow stranger rules, and Benjamin Schumacher gave quantum information a memorable name in 1995: the qubit. Your first mission is the new explorer’s map—one qubit, prepared carefully, then asked a question in a chosen measurement basis.",
      named_for: "“Qubit” is short for “quantum bit.”",
      resources: [
        { label: "Benjamin Schumacher on Wikipedia", url: "https://en.wikipedia.org/wiki/Benjamin_Schumacher" },
        { label: "Qubit overview on Wikipedia", url: "https://en.wikipedia.org/wiki/Qubit" }
      ]
    },
    "superposition" => {
      heading: "From ripples to quantum possibilities",
      body: "Long before quantum computers, scientists learned that ripples can overlap: two gentle waves can add up or cancel out. Quantum mechanics uses the same wave-style arithmetic for amplitudes. In this mission, the Hadamard gate is like opening two possible paths at once—except the paths are not classical choices waiting to be revealed.",
      named_for: "The Hadamard gate is named for French mathematician Jacques Hadamard, whose matrix is used in its definition.",
      resources: [
        { label: "Jacques Hadamard on Wikipedia", url: "https://en.wikipedia.org/wiki/Jacques_Hadamard" },
        { label: "Quantum superposition on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_superposition" }
      ]
    },
    "entanglement" => {
      heading: "1935: a puzzle with two distant quantum partners",
      body: "Einstein, Podolsky, and Rosen imagined two particles that seem to share one story even after they separate. Erwin Schrödinger replied in 1935 and called the odd connection “entanglement.” Think of a duet rather than two solo singers: the pair has a pattern that belongs to the whole song, not to either performer alone.",
      named_for: "“Entanglement” describes a joint state that cannot be split into independent states for its parts.",
      resources: [
        { label: "EPR paradox on Wikipedia", url: "https://en.wikipedia.org/wiki/EPR_paradox" },
        { label: "Erwin Schrödinger on Wikipedia", url: "https://en.wikipedia.org/wiki/Erwin_Schr%C3%B6dinger" },
        { label: "Quantum entanglement on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_entanglement" }
      ]
    },
    "bell-test" => {
      heading: "1964: John Bell turns an argument into a scoreboard",
      body: "For decades, physicists argued about whether entangled particles carried secret local instructions all along. Northern Irish physicist John Bell found a clever move in 1964: write down a score that every local hidden-instruction story must obey. Later CHSH experiments turned the score into a practical lab game—compare four settings and see whether nature crosses the classical line.",
      named_for: "Bell inequalities are named for John Bell. CHSH names John Clauser, Michael Horne, Abner Shimony, and Richard Holt.",
      resources: [
        { label: "John Stewart Bell on Wikipedia", url: "https://en.wikipedia.org/wiki/John_Stewart_Bell" },
        { label: "CHSH inequality on Wikipedia", url: "https://en.wikipedia.org/wiki/CHSH_inequality" }
      ]
    },
    "teleportation" => {
      heading: "1993: science fiction becomes a state-transfer recipe",
      body: "Teleporters belonged to science-fiction doors—step in here, appear there. In 1993, Charles Bennett and five colleagues showed a subtler quantum version: shared entanglement plus two ordinary classical bits can transfer a quantum state. No person, atom, or magical signal zips across space; the original state is consumed and rebuilt on Bob’s qubit.",
      named_for: "The protocol is called teleportation because the state is reconstructed elsewhere, not because a particle is transported.",
      resources: [
        { label: "Charles H. Bennett on Wikipedia", url: "https://en.wikipedia.org/wiki/Charles_H._Bennett_(physicist)" },
        { label: "Quantum teleportation on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_teleportation" }
      ]
    },
    "interference" => {
      heading: "1801: a screen of stripes hints at a future computer trick",
      body: "Thomas Young shone light through two slits and saw bright and dark stripes: waves were helping each other in some places and canceling in others. A century later, quantum experiments showed tiny particles follow the same amplitude rule. This mission turns that old wave puzzle into a quantum-computing trick: arrange paths so a wanted answer reinforces while another cancels.",
      named_for: "Interference is the name for waves adding constructively or destructively.",
      resources: [
        { label: "Thomas Young on Wikipedia", url: "https://en.wikipedia.org/wiki/Thomas_Young_(scientist)" },
        { label: "Double-slit experiment on Wikipedia", url: "https://en.wikipedia.org/wiki/Double-slit_experiment" }
      ]
    },
    "grovers-search" => {
      heading: "1996: Lov Grover teaches a search to whisper, then amplify",
      body: "Picture four upside-down cards. A classical helper could check them one by one. In 1996, Lov Grover described a quantum trick that does not peek at every card and announce the answer. An oracle only gives the marked card a quiet phase nudge; diffusion lets the nudge echo through interference until the marked amplitude becomes loud enough to measure.",
      named_for: "Grover’s search is named for Lov K. Grover.",
      resources: [
        { label: "Lov Grover on Wikipedia", url: "https://en.wikipedia.org/wiki/Lov_Grover" },
        { label: "Grover's algorithm on Wikipedia", url: "https://en.wikipedia.org/wiki/Grover%27s_algorithm" }
      ]
    },
    "noise-hardware" => {
      heading: "The lab door opens: the outside world keeps bumping the qubit",
      body: "On a whiteboard, a quantum state can stay perfectly balanced forever. In a real lab, stray heat, vibrations, electronics, and other surroundings keep whispering to the qubit. Those accidental whispers are noise, and they can blur the delicate phase patterns that algorithms need. Here you compare the spotless simulator sketch with a small, explicit error model.",
      named_for: "Decoherence means the loss of usable quantum coherence through interaction with an environment.",
      resources: [
        { label: "Quantum decoherence on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_decoherence" },
        { label: "Quantum noise on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_noise" }
      ]
    },
    "error-correction" => {
      heading: "1995: Peter Shor finds a way to ask an error without reading the secret",
      body: "At first, quantum error correction sounded impossible: if measuring can disturb a quantum state, how could anyone check whether it was damaged? In 1995, Peter Shor showed that several physical qubits can cooperate like a tiny team of witnesses. Parity checks ask who disagrees without asking for the protected logical answer itself.",
      named_for: "The first nine-qubit code is named for Peter Shor.",
      resources: [
        { label: "Peter Shor on Wikipedia", url: "https://en.wikipedia.org/wiki/Peter_Shor" },
        { label: "Shor code on Wikipedia", url: "https://en.wikipedia.org/wiki/Shor_code" }
      ]
    },
    "shors-factoring" => {
      heading: "1994: a hidden rhythm turns into a factoring clue",
      body: "Picture a musician tapping a repeating beat while you try to guess its cycle. In 1994, Peter Shor showed that a sufficiently capable quantum computer could turn factoring into this kind of period-finding puzzle. The news mattered because some classical cryptography relies on large numbers being hard to factor. Our version keeps the numbers tiny: we are learning the rhythm behind 15, not cracking modern secrets.",
      named_for: "Shor’s algorithm is named for Peter Shor.",
      resources: [
        { label: "Peter Shor on Wikipedia", url: "https://en.wikipedia.org/wiki/Peter_Shor" },
        { label: "Shor's algorithm on Wikipedia", url: "https://en.wikipedia.org/wiki/Shor%27s_algorithm" },
        { label: "Quantum Fourier transform on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_Fourier_transform" }
      ]
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
        body: "H prepares |+⟩. It looks 50/50 in the Z basis, but the X card shows + at 100%. The state is not a classical coin flip.",
        resources: [
          { label: "Measurement in quantum mechanics on Wikipedia", url: "https://en.wikipedia.org/wiki/Measurement_in_quantum_mechanics" }
        ]
      }
    },
    "superposition" => {
      "plus" => {
        title: "H prepares an X-basis state",
        body: "H turns |0⟩ into |+⟩. The equal Z-basis probabilities do not mean the qubit has secretly chosen a classical value."
      },
      "minus" => {
        title: "A minus sign is a relative phase",
        body: "|−⟩ has the same immediate Z-basis probabilities as |+⟩, but its |1⟩ amplitude has the opposite phase. A later gate can reveal that difference.",
        resources: [
          { label: "Quantum phase on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_phase" }
        ]
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
        body: "In the CHSH setup, local hidden-variable models cannot exceed |S| = 2. The experiment asks whether measured correlations cross that bound.",
        resources: [
          { label: "CHSH inequality on Wikipedia", url: "https://en.wikipedia.org/wiki/CHSH_inequality" }
        ]
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
        body: "Bob applies X and/or Z based on Alice’s measured bits. The classical message is why teleportation cannot send information faster than light.",
        resources: [
          { label: "Quantum teleportation on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_teleportation" }
        ]
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
        body: "H then Z still looks 50/50 in an immediate Z measurement. The phase is real information because another H can convert it into a different probability pattern.",
        resources: [
          { label: "Double-slit experiment on Wikipedia", url: "https://en.wikipedia.org/wiki/Double-slit_experiment" }
        ]
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
        body: "For larger search spaces Grover can reduce oracle calls quadratically, but someone must still build a quantum oracle that recognizes a solution.",
        resources: [
          { label: "Grover's algorithm on Wikipedia", url: "https://en.wikipedia.org/wiki/Grover%27s_algorithm" }
        ]
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
        body: "Z changes relative phase. Between two H gates, that phase change is converted into a different final Z outcome. That is why keeping phase coherent matters for quantum algorithms.",
        resources: [
          { label: "Quantum decoherence on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_decoherence" }
        ]
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
        body: "Syndrome 01 points to q2 for one bit flip. A phase flip or more than one error can fool this simple code, which is why real error correction needs richer codes.",
        resources: [
          { label: "Shor code on Wikipedia", url: "https://en.wikipedia.org/wiki/Shor_code" }
        ]
      }
    },
    "shors-factoring" => {
      "42" => {
        title: "A measurement can be a clue, not the final answer",
        body: "The first sample can land on 0000, which says little about the period. Retrying is part of the honest algorithm: later samples can land on an interference peak such as 0100."
      },
      "17" => {
        title: "Interference produces period-shaped peaks",
        body: "After the inverse QFT, 0000, 0100, 1000, and 1100 are the likely counting outcomes. Their spacing encodes quarters of a full cycle, pointing toward period 4."
      },
      "99" => {
        title: "The quantum and classical jobs are different",
        body: "The quantum routine reveals a period clue. Ordinary gcd arithmetic then turns r = 4 into the factors 3 and 5. Both parts are needed.",
        resources: [
          { label: "Quantum Fourier transform on Wikipedia", url: "https://en.wikipedia.org/wiki/Quantum_Fourier_transform" }
        ]
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
