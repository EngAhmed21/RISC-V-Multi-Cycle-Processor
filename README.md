# RISC-V-Multi-Cycle-Processor

Introduction:                                                                                                                                                                                                                                
In the dynamic landscape of computer architecture, the RISC-V instruction set has emerged as a beacon of innovation, offering an open and extensible foundation for processor design. As we navigate the intricate realm of RISC-V, this article serves as a compass, guiding us through the fundamental aspects of its instruction set and the intricacies of single-cycle and multi-cycle implementations.
At the heart of RISC-V lies its instruction set architecture (ISA), characterized by a streamlined design philosophy that emphasizes simplicity, efficiency, and openness. As we delve into the RISC-V instruction set, we will decode the architecture's unique approach to command execution, exploring how it strikes a balance between performance and versatility. From its elegant simplicity to its comprehensive set of instructions, RISC-V beckons us to rethink the way processors interpret and execute commands.
In the dance of processor design, the multi-cycle implementation of RISC-V takes center stage, introducing a more intricate choreography of clock cycles for instruction execution. This approach allows for a finer granularity of control, offering opportunities for improved performance and flexibility. As we unravel the layers of the multi-cycle architecture, we'll explore how it balances complexity with efficiency, catering to the diverse needs of modern computing.

Instruction Set Architecture:                                                                                                                                                                                                                              
Within the expansive RISC-V Instruction Set Architecture (ISA), I have taken a deliberate approach by carefully choosing a range of instructions that span various formats, including computational, control flow, and memory access. This selective approach will guide us as we design a custom Datapath and precisely specify the control signals needed to execute our chosen instructions efficiently.
The instruction set in RISC-V is organized into distinct instruction formats, with each format comprising individual "fields." These fields are essentially separate unsigned integers, each serving as a dedicated container for conveying precise information about the intended operation to be executed.
 	                                                                                                                                                                                                                                          
![image](https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/assets/90782588/ac3c0629-ffdd-48b5-8ee5-4093d55af31a)

Supported Instructions:                                                                                                                                                                                                                          
1. R-Type Instructions

   
![image](https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/assets/90782588/59f58fa4-9e0b-4df6-ade5-1f332d80704c)

2. I-Type Instructions
![image](https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/assets/90782588/92fe2a4b-bfca-4e9b-b5a3-554f1f2b8707)


3. S/B-Type Instructions
![image](https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/assets/90782588/2482f435-8f44-4c6b-a496-d9b6bc9c6f88)


4. U/J-Type Instructions
![image](https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/assets/90782588/b9ec1e60-28f1-424f-814e-02de8b615c06)


Architecture:                                                                                                                                                                                                                 

![Screenshot (858)](https://github.com/EngAhmed21/RISC-V-Multi-Cycle-Processor/assets/90782588/caa82e6d-d229-403b-ac7c-efdb55f14308)


Control Unit:                                                                                                                                                                                                                                                                                                                                                                                                                     


![Screenshot (860)](https://github.com/EngAhmed21/RISC-V-Multi-Cycle-Processor/assets/90782588/3449e82e-1913-473a-8efe-007dfe0cbec8)
                                                                                                                                                                                                
1. ALU Decoder

![Screenshot (856)](https://github.com/EngAhmed21/RISC-V-Single-Cycle-Processor/assets/90782588/e31c3cd9-0fd3-4fe0-be8e-f61e8a33f9ea)

2. Main Decoder

![Screenshot (859)](https://github.com/EngAhmed21/RISC-V-Multi-Cycle-Processor/assets/90782588/a501bc29-635e-4907-9cb8-71608940d3d3)



   
