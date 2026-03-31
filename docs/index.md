---
layout: project_page
permalink: /

title: Decentralized Safe Path Following for Multi-Quadrotor Systems
authors:
  - Hamza Tariq, Adeel Akhtar
affiliations:
  - GRaDS-Lab / New Jersey Institute of Technology 
paper:
video:
code: https://github.com/gradslab/tfl_cbf_safe_multiagent_pf
data:
---

<div class="columns is-centered has-text-centered">
  <div class="column is-four-fifths">
    <h2>Abstract</h2>
    <div class="content has-text-justified">
      This project presents a decentralized safe path-following framework for multiple quadrotors moving on intersecting paths. The controller combines path-following objectives with safety-critical constraints on attitude and inter-agent collision avoidance. A quadratic program is solved for each agent at every time step to enforce safe behavior while tracking the desired path.
    </div>
  </div>
</div>

---

## Overview

This repository contains simulation code for decentralized safe path following of multiple quadrotors.

## Method

The implementation includes:

- path-following constraints,
- roll and pitch safety constraints,
- pairwise collision avoidance constraints,
- a per-agent quadratic program solved online.

## Demo

![Four-quadrotor simulation](./static/image/quad_animation.gif)

*Figure 1: Multi-quadrotor simulation animation.*

## Repository Contents

The repository includes:

- simulation code for quadrotor dynamics,
- decentralized controller logic,
- pairwise safety constraints,
- plotting and visualization utilities.

## Requirements

```bash
pip install numpy cvxpy matplotlib
