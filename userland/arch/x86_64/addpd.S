/* https://github.com/cirosantilli/linux-kernel-module-cheat#x86-addpq-instruction
 *
 * Add a bunch of floating point numbers in one go.
 */

#include <lkmc.h>

LKMC_PROLOGUE
.bss
    output:       .skip 16
.data
    addps_input0: .float 1.5, 2.5,  3.5,  4.5
    addps_input1: .float 5.5, 6.5,  7.5,  8.5
    addps_expect: .float 7.0, 9.0, 11.0, 13.0
    addpd_input0: .double 1.5, 2.5
    addpd_input1: .double 5.5, 6.5
    addpd_expect: .double 7.0, 9.0
.text
#define TEST(size) \
    movups addp ## size ## _input0, %xmm0; \
    movups addp ## size ## _input1, %xmm1; \
    addp ## size %xmm1, %xmm0; \
    movups %xmm0, output; \
    LKMC_ASSERT_MEMCMP(output, addp ## size ## _expect, $0x10)

    /* 4x 32-bit */
    TEST(s)
    /* 2x 64-bit */
    TEST(d)
#undef TEST
LKMC_EPILOGUE
