/*
 * SPDX-FileCopyrightText: 2020 Efabless Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

// This include is relative to $CARAVEL_PATH (see Makefile)
#include "verilog/dv/caravel/defs.h"
#include "verilog/dv/caravel/stub.c"

/*
	Wishbone Test:
		- Configures MPRJ lower 8-IO pins as outputs
		- Checks led value through the wishbone port
*/

#define reg_wb_leds (*(volatile uint32_t*)0x30fffd00)
#define reg_sram (*(volatile uint32_t*)0x30000000)
#define reg_sram1 (*(volatile uint32_t*)0x30001000)

void main()
{

	/* 
	IO Control Registers
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |

	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |
	
	 
	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |

	*/

	/* Set up the housekeeping SPI to be connected internally so	*/
	/* that external pin changes don't affect it.			*/

	reg_spimaster_config = 0xa002;	// Enable, prescaler = 2,
	// connect to housekeeping SPI
	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

    reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;//led
    reg_mprj_io_20 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;//trstb
    //reg_mprj_io_19 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;//srstb

    reg_mprj_io_18 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_MGMT_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_MGMT_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	//reg_la2_oenb = reg_la2_iena = 0xFFFFFFFF;    // [95:64]

	// Flag start of the test
	reg_mprj_datal = 0x00060000;

	// set the led, signalling the end of the test
	reg_wb_leds = 0xff;
	reg_sram = 0x01234567;
	reg_sram1 = 0xdeadbeef;

	if (reg_wb_leds == 0xff && reg_sram == 0x01234567 && reg_sram1 == 0xdeadbeef) {
		reg_mprj_datal = 0x00070000;
	} else {
		reg_mprj_datal = 0x00060000;
	}
}
