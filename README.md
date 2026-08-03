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
