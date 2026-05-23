# Traffic Light Controller — FSM in Verilog HDL

Moore FSM-based 4-way traffic light controller for a highway/country-road intersection, simulated and verified in ModelSim/QuestaSim.

## State Machine

| State | Highway | Country Road | Condition to Leave |
|-------|---------|--------------|--------------------|
| S0    | GREEN   | RED          | Car detected on country road |
| S1    | YELLOW  | RED          | Timer expires (Y2RDELAY = 3 cycles) |
| S2    | RED     | RED          | Timer expires (R2GDELAY = 2 cycles) |
| S3    | RED     | GREEN        | No car on country road |
| S4    | RED     | YELLOW       | Timer expires (Y2RDELAY = 3 cycles) |

## Files

| File | Description |
|------|-------------|
| `traffic_light_controller.v` | RTL design — Moore FSM with output, next-state, and sequential blocks |
| `traffic_light_tb.v` | Testbench — 3 car-arrival stimulus events, $monitor output |

## Simulation

Tested with **ModelSim/QuestaSim**. To run:

```bash
vlog traffic_light_controller.v traffic_light_tb.v
vsim -c cat_tb -do "run -all; quit"
```

Or in Vivado:
1. Add both `.v` files to a new project (set `traffic_light_tb.v` as simulation top)
2. Run Behavioral Simulation
3. Observe waveform — confirm no simultaneous GREEN on both roads

## Waveform Results

Simulation confirms correct state sequencing across all 3 car-arrival events. No conflicting GREEN signals observed between highway and country road at any time step.

![Waveform screenshot](docs/waveform.png)

## Key Concepts Demonstrated

- Moore FSM design and implementation in Verilog
- Separation of sequential, next-state, and output always blocks
- Timer-based timed state transitions
- RTL simulation and functional verification

## Tools

- **Simulator:** ModelSim SE / QuestaSim
- **Language:** Verilog HDL (IEEE 1364-2001)
- **Course:** Digital Systems and Designs — VIT Vellore (2024–25)

## Authors

- Mohammed Anas (24BVD0097)
- Aryan Vaity (24BVD0001)
- Aditya Upadrasta (24BVD0036)
- Jeel Abhangi (24BVD0107)
