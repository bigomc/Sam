/**
 * \file
 *
 * \brief SAM LED Toggle Example
 *
 * Copyright (C) 2012-2016 Atmel Corporation. All rights reserved.
 *
 * \asf_license_start
 *
 * \page License
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of Atmel may not be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * 4. This software may only be redistributed and used in connection with an
 *    Atmel microcontroller product.
 *
 * THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
 * EXPRESSLY AND SPECIFICALLY DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * \asf_license_stop
 *
 */

/**
 * \mainpage SAM LED Toggle Example
 * See \ref appdoc_main "here" for project documentation.
 * \copydetails appdoc_preface
 *
 *
 * \page appdoc_preface Overview
 * This application demonstrates a simple example to toggle the board LED.
 */

/**
 * \page appdoc_main SAM LED Toggle Example
 *
 * Overview:
 * - \ref appdoc_sam0_led_toggle_app_intro
 * - \ref appdoc_sam0_led_toggle_app_usage
 * - \ref appdoc_sam0_led_toggle_app_compinfo
 * - \ref appdoc_sam0_led_toggle_app_contactinfo
 *
 * \section appdoc_sam0_led_toggle_app_intro Introduction
 * This application demonstrates a simple example to toggle the board LED.
 *
 * This application has been tested on following boards:
 * - SAM D20/D21/R21/D11/L21/L22/R30 Xplained Pro
 * - SAM D10 Xplained Mini
 * - SAMR21ZLL-EK
 *
 * \section appdoc_sam0_led_toggle_app_usage Usage
 * The application uses system timer to generate periodic interrupts, once the
 * interrupt occurs, LED0 will toggle.
 *
 * \section appdoc_sam0_led_toggle_app_compinfo Compilation Info
 * This software was written for the GNU GCC and IAR for ARM.
 * Other compilers may or may not work.
 *
 * \section appdoc_sam0_led_toggle_app_contactinfo Contact Information
 * For further information, visit
 * <a href="http://www.atmel.com">http://www.atmel.com</a>.
 */
/*
 * Support and FAQ: visit <a href="http://www.atmel.com/design-support/">Atmel Support</a>
 */

// From module: FreeRTOS - kernel 8.0.1
#include <FreeRTOS.h>
#include <StackMacros.h>
#include <croutine.h>
#include <event_groups.h>
#include <list.h>
#include <mpu_wrappers.h>
#include <portable.h>
#include <projdefs.h>
#include <queue.h>
#include <semphr.h>
#include <task.h>
#include <timers.h>

// From module: Common SAM0 compiler driver
#include <compiler.h>
#include <status_codes.h>

// From module: Generic board support
#include <board.h>

// From module: Interrupt management - SAM implementation
#include <interrupt.h>

// From module: PORT - GPIO Pin Control
//#include <port.h>
#include <port.h>

// From module: Part identification macros
#include <parts.h>

// From module: SYSTEM - Clock Management for SAMC20/C21
#include <clock.h>
#include <gclk.h>

// From module: SYSTEM - Core System Driver
#include <system.h>

// From module: SYSTEM - I/O Pin Multiplexer
#include <pinmux.h>

// From module: SYSTEM - Interrupt Driver For SAMC21
#include <system_interrupt.h>

// From module: SYSTEM - Power Management for SAM C20/C21
#include <power.h>

// From module: SYSTEM - Reset Management for SAM C20/C21
#include <reset.h>

#define ABOUT_TASK_PRIORITY     (tskIDLE_PRIORITY + 1)
#define ABOUT_TASK_DELAY        (100 / portTICK_RATE_MS)

/** Configure LED0, turn it off*/
static void config_led(void)
{
	struct port_config pin_conf;
	port_get_config_defaults(&pin_conf);

	pin_conf.direction  = PORT_PIN_DIR_OUTPUT;
	port_pin_set_config(LED_0_PIN, &pin_conf);
	port_pin_set_output_level(LED_0_PIN, LED_0_INACTIVE);
}

static void led_task(void *params) {
    config_led();
    while (1) {
        port_pin_toggle_output_level(LED_0_PIN);
    }
}

int main(void)
{
	system_init();

	/*Configure system tick to generate periodic interrupts */
	//SysTick_Config(system_gclk_gen_get_hz(GCLK_GENERATOR_0));
        
        xTaskCreate(led_task,
            (const char *) "Led",
            configMINIMAL_STACK_SIZE,
            NULL,
            ABOUT_TASK_PRIORITY,
            NULL);

	// ..and let FreeRTOS run tasks!
	vTaskStartScheduler();

	do {
		// Intentionally left empty
	} while (true);
}