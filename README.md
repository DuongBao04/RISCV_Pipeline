# RISC-V Pipeline

## Overview
This project implements a **5-stage RISC-V pipeline processor** with support for:
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory (MEM)
- Write Back (WB)

It includes **hazard detection** and **data forwarding** mechanisms to handle dependencies efficiently.

---

## Successful Pipeline Test

The following instructions were used to verify correct pipeline execution:

```assembly
addi x2, x0, 5   # x2 = 5
addi x3, x0, 7   # x3 = 7
addi x4, x0, 8   # x4 = 8
addi x5, x0, 9   # x5 = 9
addi x6, x0, 10  # x6 = 10
```

Result: All instructions executed successfully with correct register updates.

<p align="center"> <img src="images/PipelineSuccessful.png" alt="PipelineSuccessful" width="600"/> </p>

## Data Forwarding Test

To verify EX hazard resolution and data forwarding functionality:

```assembly
addi x2, x0, 5   # x2 = 5
addi x3, x2, 3   # x3 = 8  (depends on x2)
```


Result: The forwarding unit successfully eliminated the stall and produced the correct result.

<p align="center"> <img src="images/DataForwarding.png" alt="Data Forwarding" width="600"/> </p>
