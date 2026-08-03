# Quantum Adventure

Quantum Adventure is an account-backed Rails learning game for exploring quantum
mechanics with the local QuantumRB simulator. The first playable release covers
qubits, superposition, entanglement, and Bell tests.

## Development

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

When `../quantumrb` exists, development uses that neighboring checkout;
standalone clones fall back to the QuantumRB GitHub repository.

## Local Q-Bit tutor

Lessons include Q-Bit, a local-only chat guide. The default model is Ollama's
`llama3.2:latest` (the 3B instruction-tuned model); learner questions stay on
your machine.

```bash
ollama serve
ollama pull llama3.2:latest
```

Set `OLLAMA_MODEL` or `OLLAMA_URL` if your local setup uses a different model
or endpoint. Q-Bit is given the current mission's controls and learning goals,
so it can explain actions such as `Prepare |0⟩`, `Prepare |1⟩`, and
`Prepare |+⟩` in context.
