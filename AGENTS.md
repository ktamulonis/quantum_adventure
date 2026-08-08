# Quantum Adventure development rules

## Mission interaction

- Simulator controls in every mission must update only the experiment area with a Turbo Frame.
- Links and forms that change a prepared state, simulator input, protocol step, or other experiment setting must target that mission’s experiment frame.
- Preserve the learner’s page scroll position; do not use a full-page navigation for an in-page simulator interaction.
- Keep mission explanations, Q-Bit guidance, quizzes, and progression outside the simulator frame unless the interaction directly changes them.
