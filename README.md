# Control System

A curated collection of **control-systems simulations** for aerospace & robotics.  
Includes ready-to-run demos in **Python** (NumPy/SciPy/Matplotlib) and placeholders for **MATLAB/Simulink**.

## Why this repo?
- Reusable building blocks: models, controllers (PID, LQR, MPC), and observers (KF/EKF).
- Clear, minimal examples you can run in minutes.
- Real projects: quadrotor stabilization, rocket attitude, 4-DOF robotic arm, inverted pendulum.

## Features
- 📦 Python package: `control_systems` (transfer functions, state-space, controllers, plotting)
- 🧪 Tests with `pytest` for basic correctness
- 🧰 MATLAB/Simulink stubs mirroring Python examples
- 🔁 CI workflow (GitHub Actions) to run tests on every push
- 📚 Docs-ready (`docs/` + MkDocs/Sphinx)

## Demos (quick picks)
- `examples/mrac_controller` — mrac on a simplified model

> Tip: keep each example <100 lines, plot result, and print key metrics (overshoot, settling time).

## Install (Python)
```bash
git clone https://github.com/<you>/control-system.git
cd control-system
python -m venv .venv && source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -e . -r requirements.txt
