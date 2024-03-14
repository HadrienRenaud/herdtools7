Utils
  $ function get_expected_output () {
  >   grep '^// CHECK' "$1"
  > }

Tests

Test Imhys.asl:
  $ aslref Imhys.asl
  File Imhys.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

Test Iwxgp.asl:
  $ aslref Iwxgp.asl
  File Iwxgp.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

Test Rdpzk.asl:
  $ aslref Rdpzk.asl
  File Rdpzk.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

Test Rirnq.asl:
  $ aslref Rirnq.asl
  File Rirnq.asl, line 6, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rirnq.asl
  // CHECK: runtime_exception

Test Rmhfw.asl:
  $ aslref Rmhfw.asl
  File Rmhfw.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

Test Rvddg.asl:
  $ aslref Rvddg.asl
  File Rvddg.asl, line 5, characters 4 to 18:
  ASL Error: Undefined identifier: 'Unreachable'
  [1]

Test Ibklj.asl:
  $ aslref Ibklj.asl

Test Icxps.asl:
  $ aslref Icxps.asl
  Hello world
For reference, the test writter intention was that this output matched:
  $ get_expected_output Icxps.asl
  // CHECK: Hello world

Test Rbsqr.asl
  $ aslref Rbsqr.asl

Test Rchth.asl:
  $ aslref Rchth.asl
  [1]

Test Rjwph.asl:
  $ aslref Rjwph.asl
  File Rjwph.asl, line 6, characters 4 to 27:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rjwph.asl
  // CHECK: Hello World

Test Rxnsk.asl:
  $ aslref Rxnsk.asl
  File Rxnsk.asl, line 8, characters 10 to 11:
  ASL Error: Undefined identifier: 'a'
  [1]

Test Dgvbk.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dgvbk.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Inxkd.asl:
  $ aslref Inxkd.asl

Test Rfrwd.asl:
  $ aslref Rfrwd.asl

Test Rswqd.asl:
  $ aslref Rswqd.asl
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rswqd.asl
  // CHECK-NOT: 10

Test Ihjcd.asl:
  $ aslref Ihjcd.asl
  1000000
  1000000
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ihjcd.asl
  // CHECK: 1000000
  // CHECK-NEXT: 1000000

Test Ipbpq.asl:
  $ aslref Ipbpq.asl
  File Ipbpq.asl, line 8, characters 13 to 32:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ipbpq.asl
  // CHECK: TRUE
  // CHECK-NEXT: TRUE

Test Iqczx.asl:
  $ aslref Iqczx.asl
  File Iqczx.asl, line 7, characters 13 to 39:
  ASL Typing error: Illegal application of operator + on types string
    and bits(16)
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iqczx.asl
  // CHECK: 0xFFFF
  // CHECK-NEXT: 0xFFFF

Test Rhyfh.asl:
  $ aslref Rhyfh.asl
  File Rhyfh.asl, line 11, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer {10}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rhyfh.asl
  // CHECK: 10
  // CHECK-NEXT: 10
  // CHECK-NEXT: 10
  // CHECK-NEXT: 10
  // CHECK-NEXT: 10
  // CHECK-NEXT: 10

Test Rmxps.asl:
  $ aslref Rmxps.asl
  File Rmxps.asl, line 7, characters 13 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rmxps.asl
  // CHECK: FALSE
  // CHECK-NEXT: TRUE

Test Rpbfk.asl:
  $ aslref Rpbfk.asl
  File Rpbfk.asl, line 8, characters 13 to 24:
  ASL Typing error: Illegal application of operator + on types string
    and bits(4)
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rpbfk.asl
  // CHECK: 0x0
  // CHECK-NEXT: 0xF
  // CHECK-NEXT: 0x0

Test Rqqbb.asl:
  $ aslref Rqqbb.asl
  File Rqqbb.asl, line 11, characters 13 to 22:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rqqbb.asl
  // CHECK: 10.0
  // CHECK-NEXT: 10.0
  // CHECK-NEXT: 10.0
  // CHECK-NEXT: 10.0
  // CHECK-NEXT: 10.0
  // CHECK-NEXT: 10.0

Test Rrymd.asl:
  $ aslref Rrymd.asl

Test Rzrvy.asl:
  $ aslref Rzrvy.asl
  File Rzrvy.asl, line 10, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rzrvy.asl
  // CHECK: hello
  // CHECK-NEXT: wor"ld
  // CHECK-NEXT: te\st
  // CHECK-NEXT: bre
  // CHECK-NEXT: ak

Test Ihvlx.asl:
  $ aslref Ihvlx.asl

Test Iscly.asl:
  $ aslref Iscly.asl
  File Iscly.asl, line 5, characters 8 to 12:
  ASL Error: Cannot parse.
  [1]

Test Rhprd.asl:
  $ aslref Rhprd.asl

Test Rjgrk.asl:
  $ aslref Rjgrk.asl

Test Rqmdm.asl:
  $ aslref Rqmdm.asl

Test Rgfsh.asl:
  $ aslref Rgfsh.asl
  File Rgfsh.asl, line 5, characters 11 to 17:
  ASL Error: Undefined identifier: 'String'
  [1]

Test Ddpxj.asl:
  $ aslref Ddpxj.asl

Test Ipgss.asl:
  $ aslref Ipgss.asl
  File Ipgss.asl, line 8, characters 13 to 22:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ipgss.asl
  // CHECK: 0
  // CHECK-NEXT: 0

Test Rdgjt.asl:
  $ aslref Rdgjt.asl

Test Rhhcd.asl:
  $ aslref Rhhcd.asl
  File Rhhcd.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Rjjcj.asl:
  $ aslref Rjjcj.asl

Test Rpxrr.asl:
  $ aslref Rpxrr.asl

Test Rwgvr.asl:
  $ aslref Rwgvr.asl
  File Rwgvr.asl, line 7, characters 13 to 22:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rwgvr.asl
  // CHECK: 0

Test Ryhnv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ryhnv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ihmrk.asl:
  $ aslref Ihmrk.asl
  File Ihmrk.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ihmrk.asl
  // CHECK: 0
  // CHECK-NEXT: FALSE

Test Imqwb.asl:
  $ aslref Imqwb.asl

Test Rcgwr.asl:
  $ aslref Rcgwr.asl

Test Rjhkl.asl:
  $ aslref Rjhkl.asl
  File Rjhkl.asl, line 6, characters 4 to 5:
  ASL Typing error: integer {10} does not subtype any of: bits(-), record {  },
    exception {  }.
  [1]

Test Rqwsq.asl:
  $ aslref Rqwsq.asl
  File Rqwsq.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rqwsq.asl
  // CHECK: 0
  // CHECK-NEXT: 0

Test Rtvpr.asl:
  $ aslref Rtvpr.asl

Test Dwgqs.asl:
  $ aslref Dwgqs.asl

Test Itfps.asl:
  $ aslref Itfps.asl

Test Rdlxv.asl:
  $ aslref Rdlxv.asl
  File Rdlxv.asl, line 14, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rdlxv.asl
  // CHECK: 10

Test Rdxwn.asl:
  $ aslref Rdxwn.asl

Test Rmbrm.asl:
  $ aslref Rmbrm.asl
  File Rmbrm.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rmbrm.asl
  // CHECK: 0

Test Rmdzd.asl:
  $ aslref Rmdzd.asl
  File Rmdzd.asl, line 3, character 0 to line 6, character 2:
  ASL Typing error: cannot declare already declared element "b".
  [1]

Test Rwfmf.asl:
  $ aslref Rwfmf.asl

Test Dqxyc.asl:
  $ aslref Dqxyc.asl

Test Ihlbl.asl:
  $ aslref Ihlbl.asl

Test Rbwdx.asl:
  $ aslref Rbwdx.asl
  File Rbwdx.asl, line 23, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

Test Rchkr.asl:
  $ aslref Rchkr.asl
  File Rchkr.asl, line 3, character 0 to line 6, character 2:
  ASL Typing error: cannot declare already declared element "b".
  [1]

Test Rkgxl.asl:
  $ aslref Rkgxl.asl

Test Rmghv.asl:
  $ aslref Rmghv.asl

Test Rsvjb.asl:
  $ aslref Rsvjb.asl
  File Rsvjb.asl, line 12, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

Test Rmhwm.asl:
  $ aslref Rmhwm.asl

Test Dknbd.asl:
  $ aslref Dknbd.asl

Test Dnzwt.asl:
  $ aslref Dnzwt.asl

Test Dpqck.asl:
  $ aslref Dpqck.asl

Test Rgvzk.asl:
  $ aslref Rgvzk.asl

Test Rgrvj.asl:
  $ aslref Rgrvj.asl
  Fatal error: exception Not_found
  [2]

Test Gpfrq.asl:
  $ aslref Gpfrq.asl

Test Dztpp.asl:
  $ aslref Dztpp.asl

Test Dzxss.asl:
  $ aslref Dzxss.asl

Test Ighgk.asl:
  $ aslref Ighgk.asl
  File Ighgk.asl, line 3, characters 34 to 35:
  ASL Error: Cannot parse.
  [1]

Test Izddj.asl:
  $ aslref Izddj.asl
  File Izddj.asl, line 3, characters 34 to 35:
  ASL Error: Cannot parse.
  [1]

Test Rbsmk.asl:
  $ aslref Rbsmk.asl

Test Rcztx.asl:
  $ aslref Rcztx.asl

Test Rgwcp.asl:
  $ aslref Rgwcp.asl

Test Rhjpn.asl:
  $ aslref Rhjpn.asl

Test Rlsnp.asl:
  $ aslref Rlsnp.asl

Test Rtphr.asl:
  $ aslref Rtphr.asl
  File Rtphr.asl, line 3, characters 34 to 35:
  ASL Error: Cannot parse.
  [1]

Test Rwjyh.asl:
  $ aslref Rwjyh.asl

Test Ibbqr.asl:
  $ aslref Ibbqr.asl

Test Icdvy.asl:
  $ aslref Icdvy.asl
  File Icdvy.asl, line 3, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

Test Ikfcr.asl:
  $ aslref Ikfcr.asl
  File Ikfcr.asl, line 3, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

Test Iwbwl.asl:
  $ aslref Iwbwl.asl

Test Iwlpj.asl:
  $ aslref Iwlpj.asl

Test Rfwmm.asl:
  $ aslref Rfwmm.asl

Test Rlyds.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rlyds.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rrlqp.asl:
  $ aslref Rrlqp.asl

Test Rsvdj.asl:
  $ aslref Rsvdj.asl

Test Rtznr.asl:
  $ aslref Rtznr.asl
  File Rtznr.asl, line 3, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

Test Iwvqz.asl:
  $ aslref Iwvqz.asl

Test Rcftd.asl:
  $ aslref Rcftd.asl
  File Rcftd.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {4..10}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rcftd.asl
  // CHECK: 4
  // CHECK-NEXT: -4
  // CHECK-NEXT: 4

Test Rnjdz.asl:
  $ aslref Rnjdz.asl
  File Rnjdz.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rnjdz.asl
  // CHECK: 0

Test Rqggh.asl:
  $ aslref Rqggh.asl

Test Ihjbh.asl:
  $ aslref Ihjbh.asl
  File Ihjbh.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ihjbh.asl
  // CHECK: 99999999999999999999999999999999999999999999999
  // CHECK-NEXT: -99999999999999999999999999999999999999999999999

Test Dcqxl.asl:
  $ aslref Dcqxl.asl
  File Dcqxl.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Dcqxl.asl
  // CHECK: 3.141590e+0

Test Ijqpk.asl:
  $ aslref Ijqpk.asl
  File Ijqpk.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ijqpk.asl
  // CHECK: 10

Test Iwjcl.asl:
  $ aslref Iwjcl.asl
  File Iwjcl.asl, line 11, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iwjcl.asl
  // CHECK: 1
  // CHECK-NEXT: 2

Test Iyftf.asl:
  $ aslref Iyftf.asl

Test Rgycg.asl:
  $ aslref Rgycg.asl
  File Rgycg.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rgycg.asl
  // CHECK: 0.0

Test Rxcjd.asl:
  $ aslref Rxcjd.asl
  File Rxcjd.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rxcjd.asl
  // CHECK: 1.000000e+69
  // CHECK-NEXT: -1.000000e+69
  // CHECK-NEXT: 1.000000e-70

Test Idmnl.asl:
  $ aslref Idmnl.asl
  File Idmnl.asl, line 8, characters 13 to 32:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Idmnl.asl
  // CHECK: TRUE
  // CHECK-NEXT: TRUE

Test Rwkcy.asl:
  $ aslref Rwkcy.asl
  File Rwkcy.asl, line 7, characters 4 to 15:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rwkcy.asl
  // CHECK:

Test Dyzbq.asl:
  $ aslref Dyzbq.asl

Test Imzxl.asl:
  $ aslref Imzxl.asl

Test Iprpy.asl:
  $ aslref Iprpy.asl
  File Iprpy.asl, line 8, characters 21 to 27:
  ASL Typing error: Illegal application of operator <= on types enum and enum
  [1]

Test Iqmwt.asl:
  $ aslref Iqmwt.asl

Test Rdwsp.asl:
  $ aslref Rdwsp.asl
  File Rdwsp.asl, line 3, characters 0 to 31:
  ASL Typing error: cannot declare already declared element "A".
  [1]

Test Rhjyj.asl:
  $ aslref Rhjyj.asl

Test Rlccn.asl:
  $ aslref Rlccn.asl
  File Rlccn.asl, line 8, characters 13 to 26:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rlccn.asl
  // CHECK: TRUE

Test Rcpck.asl:
  $ aslref Rcpck.asl
  File Rcpck.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rcpck.asl
  // CHECK: FALSE

Test Dbvgk.asl:
  $ aslref Dbvgk.asl
  File Dbvgk.asl, line 3, characters 33 to 34:
  ASL Error: Cannot parse.
  [1]

Test Dcbqk.asl:
  $ aslref Dcbqk.asl

Test Dnrwc.asl:
  $ aslref Dnrwc.asl

Test Dwszm.asl:
  $ aslref Dwszm.asl

Test Imrhk.asl:
  $ aslref Imrhk.asl

Test Iybhf.asl:
  $ aslref Iybhf.asl

Test Rfzsd.asl:
  $ aslref Rfzsd.asl
  File Rfzsd.asl, line 3, characters 15 to 16:
  ASL Error: Cannot parse.
  [1]

Test Rljbg.asl:
  $ aslref Rljbg.asl
  File Rljbg.asl, line 3, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

Test Rnfbn.asl:
  $ aslref Rnfbn.asl
  File Rnfbn.asl, line 5, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

Test Rqyzd.asl:
  $ aslref Rqyzd.asl
  File Rqyzd.asl, line 5, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

Test Igqmv.asl:
  $ aslref Igqmv.asl
  File Igqmv.asl, line 3, characters 15 to 33:
  ASL Error: Unsupported expression 4 as integer {4, 8}.
  [1]

Test Ijskw.asl:
  $ aslref Ijskw.asl

Test Rghrp.asl:
  $ aslref Rghrp.asl
  ASL Error: Undefined identifier: 'a'
  [1]

Test Rncnq.asl:
  $ aslref Rncnq.asl
  File Rncnq.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Rqzjs.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rqzjs.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rskrk.asl:
  $ aslref Rskrk.asl
  ASL Error: Undefined identifier: 'a'
  [1]

Test Iqfzh.asl:
  $ aslref Iqfzh.asl
  File Iqfzh.asl, line 7, characters 13 to 29:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iqfzh.asl
  // CHECK: TRUE

Test Irxlg.asl:
  $ aslref Irxlg.asl
  File Irxlg.asl, line 16, characters 13 to 26:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Irxlg.asl
  // CHECK: FALSE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: 0x5
  // CHECK-NEXT: 0x4
  // CHECK-NEXT: 0x2
  // CHECK-NEXT: 0x1
  // CHECK-NEXT: 0x1

Test Isqvv.asl:
  $ aslref Isqvv.asl

Test Ivmkf.asl:
  $ aslref Ivmkf.asl
  File Ivmkf.asl, line 7, characters 13 to 31:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ivmkf.asl
  // CHECK: TRUE

Test Ivpst.asl:
  $ aslref Ivpst.asl
  File Ivpst.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Rdhzt.asl:
  $ aslref Rdhzt.asl

Test Rdkgq.asl:
  $ aslref Rdkgq.asl

Test Rpmqb.asl:
  $ aslref Rpmqb.asl

Test Rqxgw.asl:
  $ aslref Rqxgw.asl
  File Rqxgw.asl, line 7, characters 14 to 15:
  ASL Error: Cannot parse.
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rqxgw.asl
  // CHECK: TRUE

Test Rzrwh.asl:
  $ aslref Rzrwh.asl

Test Rzvpt.asl:
  $ aslref Rzvpt.asl
  File Rzvpt.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and bits(32)
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rzvpt.asl
  // CHECK: 0x0

Test Rzwgh.asl:
  $ aslref Rzwgh.asl

Test Iglwm.asl:
  $ aslref Iglwm.asl
  File Iglwm.asl, line 5, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

Test Imtwl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Imtwl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Itzvj_a.asl:
  $ aslref Itzvj_a.asl
  File Itzvj_a.asl, line 3, characters 23 to 30:
  ASL Error: Cannot parse.
  [1]

Test Itzvj_b.asl:
  $ aslref Itzvj_b.asl

Test Rvczx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rvczx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rvczx.asl, line 3, characters 15 to 16:
  ASL Error: Cannot parse.
  [1]

Test Ieoax.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ieoax.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Inhxt.asl:
  $ aslref Inhxt.asl

Test Icgyh.asl:
  $ aslref Icgyh.asl

Test Ifpvz.asl:
  $ aslref Ifpvz.asl
  File Ifpvz.asl, line 3, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

Test Iqnsd.asl:
  $ aslref Iqnsd.asl
  File Iqnsd.asl, line 16, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

Test Ibghb.asl:
  $ aslref Ibghb.asl

Test Ifzms.asl:
  $ aslref Ifzms.asl

Test Ijdcc.asl:
  $ aslref Ijdcc.asl
  File Ijdcc.asl, line 3, character 0 to line 5, character 2:
  ASL Typing error: Cannot extract from bitvector of length 5 slices 10:7.
  [1]

Test Ikgmc.asl:
  $ aslref Ikgmc.asl

Test Ikpbx.asl:
  $ aslref Ikpbx.asl

Test Iqdhp.asl:
  $ aslref Iqdhp.asl

Test Rbdjk.asl:
  $ aslref Rbdjk.asl
  File Rbdjk.asl, line 3, character 0 to line 5, character 2:
  ASL Typing error: overlapping slices 1:3.
  [1]

Test Rcgdg.asl:
  $ aslref Rcgdg.asl

Test Rchbw.asl:
  $ aslref Rchbw.asl

Test Rcnhb.asl:
  $ aslref Rcnhb.asl
  File Rcnhb.asl, line 3, character 0 to line 5, character 2:
  ASL Typing error: overlapping slices 3:0, 3:1.
  [1]

Test Rgqvz.asl:
  $ aslref Rgqvz.asl
  File Rgqvz.asl, line 17, characters 13 to 43:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rgqvz.asl
  // CHECK: TRUE
  // CHECK-NEXT: TRUE

Test Rlghs.asl:
  $ aslref Rlghs.asl
  File Rlghs.asl, line 4, characters 4 to 5:
  ASL Error: Cannot parse.
  [1]

Test Rmpmg.asl:
  $ aslref Rmpmg.asl
  File Rmpmg.asl, line 3, character 0 to line 6, character 2:
  ASL Typing error: cannot declare already declared element "aa".
  [1]

Test Rmxyq.asl:
  $ aslref Rmxyq.asl

Test Rqcym.asl:
  $ aslref Rqcym.asl

Test Rrmtq.asl:
  $ aslref Rrmtq.asl

Test Ryypn.asl:
  $ aslref Ryypn.asl
  File Ryypn.asl, line 5, characters 27 to 28:
  ASL Error: Cannot parse.
  [1]

Test Rzjsh.asl:
  $ aslref Rzjsh.asl

Test Dwxqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dwxqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Iscbx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Iscbx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Uxknl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Uxknl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ibyvl.asl:
  $ aslref Ibyvl.asl
  File Ibyvl.asl, line 9, characters 0 to 3:
  ASL Error: Cannot parse.
  [1]

Test Ijrdl.asl:
  $ aslref Ijrdl.asl

Test Iwykz.asl:
  $ aslref Iwykz.asl

Test Ihjrd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ihjrd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ihjrd.asl, line 16, characters 0 to 14:
  ASL Typing error: multiple recursive declarations: "a", "a", "a"
  [1]

Test Ilwqq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ilwqq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Imvnz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Imvnz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rdhrc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rdhrc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rswvp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rswvp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ihsww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ihsww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ihsww.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ihsww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 10
  [1]

Output is non-deterministic
$ bash run.sh aslref Ijvrm.asl
Segmentation fault (core dumped)
[139]

Test Ikgks.asl:
  $ aslref Ikgks.asl

Test Imtml.asl:
  $ aslref Imtml.asl

Test Rhqzy.asl:
  $ aslref Rhqzy.asl

Test Rlpdl.asl:
  $ aslref Rlpdl.asl
  File Rlpdl.asl, line 3, characters 0 to 29:
  ASL Error: Undefined identifier: 'a'
  [1]

Test Rnxrx.asl:
  $ aslref Rnxrx.asl

Test Rsrhn.asl:
  $ aslref Rsrhn.asl
  File Rsrhn.asl, line 4, characters 0 to 28:
  ASL Typing error: a subtype of a was expected, provided string.
  [1]

Test Rzrkm.asl:
  $ aslref Rzrkm.asl

Test Rzwhp.asl:
  $ aslref Rzwhp.asl

Test Rkdks.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rkdks.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

# Output is non-deterministic
$ bash run.sh aslref Rybwy.asl
Segmentation fault (core dumped)
[139]

Test Iglhk.asl:
  $ aslref Iglhk.asl

Test Ivylk.asl:
  $ aslref Ivylk.asl
  File Ivylk.asl, line 3, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

Test Rckgp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rckgp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rdjmc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rdjmc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rdlxt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rdlxt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rfkgp.asl:
  $ aslref Rfkgp.asl
  File Rfkgp.asl, line 5, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rfpmt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rfpmt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rfpmt.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rfpmt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 30
  [1]

Test Rgbnc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rgbnc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rgbnc.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rgbnc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 0
  [1]

Test Rplyx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rplyx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rprzn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rprzn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rprzn.asl, line 5, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rrzll.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rrzll.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ivqhq.asl:
  $ aslref Ivqhq.asl

Test Iypxd.asl:
  $ aslref Iypxd.asl
  File Iypxd.asl, line 3, characters 4 to 5:
  ASL Error: Cannot parse.
  [1]

Test Rbhmy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rbhmy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rdbzz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rdbzz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rksqp_a.asl:
  $ aslref Rksqp_a.asl
  File Rksqp_a.asl, line 3, characters 14 to 15:
  ASL Error: Cannot parse.
  [1]

Test Rksqp_b.asl:
  $ aslref Rksqp_b.asl
  File Rksqp_b.asl, line 3, characters 19 to 20:
  ASL Error: Cannot parse.
  [1]

Test Rksqp_c.asl:
  $ aslref Rksqp_c.asl
  File Rksqp_c.asl, line 3, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

Test Rpnqj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rpnqj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rsblx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rsblx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rtrdj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rtrdj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rwzjq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rwzjq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rznth.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rznth.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dgwwp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dgwwp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ibcww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ibcww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ifyfn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ifyfn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ifyfn.asl, line 10, characters 4 to 27:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rsfpm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rsfpm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rsfpm.asl, line 12, characters 4 to 27:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rfrdx.asl:
  $ aslref Rfrdx.asl

Test Rjgvx.asl:
  $ aslref Rjgvx.asl

Test Rrxhx.asl:
  $ aslref Rrxhx.asl

Test Dbhpj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dbhpj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dmryb.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dmryb.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ifbvh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ifbvh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Iqjnf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Iqjnf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Iwhlv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Iwhlv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rlcsz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rlcsz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rmbzp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rmbzp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rmzjj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rmzjj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rnctb.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rnctb.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rqkxv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rqkxv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rtjrh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rtjrh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rtjrh.asl, line 3, characters 0 to 16:
  ASL Typing error: multiple recursive declarations: "_a", "_a"
  [1]

Test Djwkg.asl:
  $ aslref Djwkg.asl

Test Djwxx.asl:
  $ aslref Djwxx.asl

Test Dqmyp.asl:
  $ aslref Dqmyp.asl

Test Dvftv.asl:
  $ aslref Dvftv.asl

Test Idvsm.asl:
  $ aslref Idvsm.asl

Test Igklw.asl:
  $ aslref Igklw.asl
  ASL Error: Arity error while calling 'main':
    1 arguments expected and 0 provided
  [1]

Test Ipfng.asl:
  $ aslref Ipfng.asl

Test Itwjf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Itwjf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Itwjf.asl, line 8, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Itwjf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 5
  // CHECK-NEXT: 5
  // CHECK-NEXT: 5
  [1]

Test Rdfwz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rdfwz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rhdgv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rhdgv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rhdgv.asl, line 3, characters 0 to 15:
  ASL Typing error: multiple recursive declarations: "a", "a"
  [1]

Test Rjbxs.asl:
  $ aslref Rjbxs.asl

Test Rkcmk.asl:
  $ aslref Rkcmk.asl
  File Rkcmk.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

Test Rkfgj.asl:
  $ aslref Rkfgj.asl

Test Rptdd.asl:
  $ aslref Rptdd.asl

Test Rqcvm.asl:
  $ aslref Rqcvm.asl

Test Rwkhc_a.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rwkhc_a.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rwkhc_b.asl:
  $ aslref Rwkhc_b.asl
  File Rwkhc_b.asl, line 6, characters 0 to 3:
  ASL Error: Cannot parse.
  [1]

Test Dnmfp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dnmfp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Itsxl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Itsxl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Itsxl.asl, line 9, characters 18 to 25:
  ASL Typing error: (integer {10}, integer {20}) does not subtype any of:
    bits(-), record {  }, exception {  }.
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Itsxl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 10
  // CHECK-NEXT: 20
  [1]

Test Ixfpv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ixfpv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ixfpv.asl, line 9, characters 12 to 19:
  ASL Typing error: (integer {10}, integer {20}) does not subtype any of:
    bits(-), record {  }, exception {  }.
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ixfpv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 10
  // CHECK-NEXT: 20
  [1]

Test Rjpvl.asl:
  $ aslref Rjpvl.asl
  File Rjpvl.asl, line 13, characters 4 to 5:
  ASL Error: Cannot parse.
  [1]

Test Rkvnx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rkvnx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rkvnx.asl, line 7, characters 4 to 5:
  ASL Typing error: integer {4} does not subtype any of: bits(-), record {  },
    exception {  }.
  [1]

Test Isbfk.asl:
  $ aslref Isbfk.asl

Test Rhdds.asl:
  $ aslref Rhdds.asl

Test Rpblf.asl:
  $ aslref Rpblf.asl

Test Igjhs.asl:
  $ aslref Igjhs.asl

Test Rwlch.asl:
  $ aslref Rwlch.asl

Test Rxbmn.asl:
  $ aslref Rxbmn.asl

Test Rycdb.asl:
  $ aslref Rycdb.asl
  File Rycdb.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {10, 5}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rycdb.asl
  // CHECK: 10
  // CHECK-NEXT: 5
  // CHECK-NEXT: 3

Test Iwlnm.asl:
  $ aslref Iwlnm.asl
  File Iwlnm.asl, line 3, characters 8 to 14:
  ASL Error: Cannot parse.
  [1]

Test Rzndl.asl:
  $ aslref Rzndl.asl
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rzndl.asl
  // CHECK-: TRUE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: FALSE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: FALSE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: FALSE

Test Rrcsd.asl:
  $ aslref Rrcsd.asl
  File Rrcsd.asl, line 12, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

Test Rdyqz.asl:
  $ aslref Rdyqz.asl
  File Rdyqz.asl, line 10, characters 12 to 24:
  ASL Error: Fields mismatch for creating a value of type a
    -- Passed fields are: x
  [1]

Test Rwbcq.asl:
  $ aslref Rwbcq.asl

Test Rkcds.asl:
  $ aslref Rkcds.asl
  File Rkcds.asl, line 10, characters 12 to 24:
  ASL Error: Fields mismatch for creating a value of type a
    -- Passed fields are: x
  [1]

Test Rzwch.asl:
  $ aslref Rzwch.asl

Test Iqslr.asl:
  $ aslref Iqslr.asl

Test Ivgsp.asl:
  $ aslref Ivgsp.asl
  File Ivgsp.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

Test Iwdmd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Iwdmd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rlljz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rlljz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rqnqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rqnqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rsppt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rsppt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rytky.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rytky.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rzdsj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rzdsj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ijejd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ijejd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Itfsz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Itfsz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rktbg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rktbg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rnhgp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rnhgp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rnhgp.asl, line 7, characters 4 to 18:
  ASL Typing error: a subtype of integer was expected, provided bits((b + 1)).
  [1]

Test Rsnqj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rsnqj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rwzcs.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rwzcs.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  Fatal error: exception Invalid_argument("List.init")
  [1]

Test Rdvvq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rdvvq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rdvvq.asl, line 18, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rdvvq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 30
  // CHECK-NEXT: 10
  [1]

Test Rgxqh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rgxqh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rztrr.asl:
  $ aslref Rztrr.asl
  File Rztrr.asl, line 6, characters 12 to 18:
  ASL Typing error: a subtype of integer {0..(10 - 1)} was expected,
    provided integer {100}.
  [1]

Test Dkxwt.asl:
  $ aslref Dkxwt.asl

Test Ihsql.asl:
  $ aslref Ihsql.asl

Test Rdgrv.asl:
  $ aslref Rdgrv.asl
  File Rdgrv.asl, line 7, characters 8 to 25:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rdgrv.asl
  // CHECK: Hello
  // CHECK-NEXT: World

Test Rgvcc.asl:
  $ aslref Rgvcc.asl
  Uncaught exception: a {}
  [1]

Test Rtxtc.asl:
  $ aslref Rtxtc.asl
  File Rtxtc.asl, line 14, characters 21 to 51:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rtxtc.asl
  // CHECK: Caught correctly
  // CHECK-NEXT: Caught incorrectly

Test Dggcq.asl:
  $ aslref Dggcq.asl
  File Dggcq.asl, line 15, characters 32 to 42:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Dggcq.asl
  // CHECK: 10

Test Djtdg.asl:
  $ aslref Djtdg.asl
  File Djtdg.asl, line 15, characters 32 to 42:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Djtdg.asl
  // CHECK: 10

Test Igzvm.asl:
  $ aslref Igzvm.asl
  File Igzvm.asl, line 17, characters 32 to 42:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Igzvm.asl
  // CHECK: 10

Test Rdhkh.asl:
  $ aslref Rdhkh.asl
  File Rdhkh.asl, line 14, characters 23 to 25:
  ASL Typing error: cannot assign to immutable storage "aa".
  [1]

Test Rjzst.asl:
  $ aslref Rjzst.asl
  File Rjzst.asl, line 13, characters 18 to 32:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rjzst.asl
  // CHECK: aa
  // CHECK-NEXT: bb

Test Rmkgb.asl:
  $ aslref Rmkgb.asl
  File Rmkgb.asl, line 17, characters 18 to 20:
  ASL Error: Undefined identifier: 'aa'
  [1]

Test Rspnm.asl:
  $ aslref Rspnm.asl
  File Rspnm.asl, line 17, characters 21 to 38:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rspnm.asl
  // CHECK: b
  // CHECK-NEXT: a
  // CHECK-NEXT: other

Test Ryvxf.asl:
  $ aslref Ryvxf.asl
  File Ryvxf.asl, line 15, characters 21 to 38:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Ryvxf.asl
  // CHECK: a

Test Rztlb.asl:
  $ aslref Rztlb.asl
  File Rztlb.asl, line 14, characters 22 to 35:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rztlb.asl
  // CHECK: a

Test Iyklf.asl:
  $ aslref Iyklf.asl
  File Iyklf.asl, line 16, characters 18 to 31:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iyklf.asl
  // CHECK: a

Test Rbrcj.asl:
  $ aslref Rbrcj.asl
  Uncaught exception: implicitely thrown out of a try-catch.
  [1]

Test Rgvks.asl:
  $ aslref Rgvks.asl
  File Rgvks.asl, line 15, characters 18 to 31:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rgvks.asl
  // CHECK: a

Test Rptng.asl:
  $ aslref Rptng.asl

Test Ikbxm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ikbxm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ikbxm.asl, line 5, characters 12 to 13:
  ASL Error: Undefined identifier: 'c'
  [1]

Test Rjfrd.asl:
  $ aslref Rjfrd.asl
  File Rjfrd.asl, line 9, characters 12 to 13:
  ASL Error: Undefined identifier: 'a'
  [1]

Test Rlcfd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rlcfd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ifkjc.asl:
  $ aslref Ifkjc.asl

Test Rjnmr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rjnmr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rjnmr.asl, line 5, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rkszm.asl:
  $ aslref Rkszm.asl
  File Rkszm.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rkszm.asl
  // CHECK: 0

Test Rtzrv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rtzrv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rxylp.asl:
  $ aslref Rxylp.asl
  File Rxylp.asl, line 5, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

Test Rzxhp.asl:
  $ aslref Rzxhp.asl
  File Rzxhp.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {2}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rzxhp.asl
  // CHECK: 1
  // CHECK-NEXT: 2
  // CHECK-NEXT: 3

Test Rbfwl.asl:
  $ aslref Rbfwl.asl

Test Rclqj.asl:
  $ aslref Rclqj.asl

Test Rfmlk.asl:
  $ aslref Rfmlk.asl

Test Rnxsf.asl:
  $ aslref Rnxsf.asl

Test Rqdqd.asl:
  $ aslref Rqdqd.asl
  File Rqdqd.asl, line 5, characters 13 to 14:
  ASL Error: Cannot parse.
  [1]

Test Rsqjj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rsqjj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rtfjz.asl:
  $ aslref Rtfjz.asl

Test Rxhpb.asl:
  $ aslref Rxhpb.asl

Test Rxsdc.asl:
  $ aslref Rxsdc.asl

Test Dkcyt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dkcyt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Dkcyt.asl, line 10, characters 4 to 8:
  ASL Error: Mismatched use of return value from call to 'a'
  [1]

Test Dhtpl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dhtpl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rnywh.asl:
  $ aslref Rnywh.asl
  File Rnywh.asl, line 5, characters 4 to 14:
  ASL Typing error: cannot return something from a procedure.
  [1]

Test Rphnz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rphnz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ryyfr.asl:
  $ aslref Ryyfr.asl

Test Rzhyt.asl:
  $ aslref Rzhyt.asl
  File Rzhyt.asl, line 12, characters 4 to 14:
  ASL Typing error: a subtype of bits(-) was expected, provided a.
  [1]

Test Dwsxy.asl:
  $ aslref Dwsxy.asl
  File Dwsxy.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {1}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Dwsxy.asl
  // CHECK: 1
  // CHECK-NEXT: 2

Test Icjvd.asl:
  $ aslref Icjvd.asl

Test Issxj.asl:
  $ aslref Issxj.asl

Test Rzhvh.asl:
  $ aslref Rzhvh.asl
  File Rzhvh.asl, line 5, characters 4 to 27:
  ASL Error: Arity error while calling 'tuple initialization':
    3 arguments expected and 2 provided
  [1]

Test Rydfq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rydfq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rydfq.asl, line 19, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rydfq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: 4
  [1]

Test Dbjny.asl:
  $ aslref Dbjny.asl

Test Dqjyv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dqjyv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rwqrn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rwqrn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rwzsl.asl:
  $ aslref Rwzsl.asl
  File Rwzsl.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

Test Rkztj.asl:
  $ aslref Rkztj.asl
  File Rkztj.asl, line 7, characters 4 to 17:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rkztj.asl
  // CHECK: 0
  // CHECK-NEXT: 3

Test Rtmys.asl:
  $ aslref Rtmys.asl
  File Rtmys.asl, line 7, characters 8 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rtmys.asl
  // CHECK: 3

Test Rxssl.asl:
  $ aslref Rxssl.asl
  File Rxssl.asl, line 7, characters 8 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rxssl.asl
  // CHECK: 2

Test Rcwnt.asl:
  $ aslref Rcwnt.asl
  File Rcwnt.asl, line 18, characters 13 to 31:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rcwnt.asl
  // CHECK: 3

Test Rjhst.asl:
  $ aslref Rjhst.asl
  File Rjhst.asl, line 7, characters 23 to 36:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rjhst.asl
  // CHECK: 3

Test Rjvtr.asl:
  $ aslref Rjvtr.asl
  File Rjvtr.asl, line 6, characters 22 to 39:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rrxqb.asl:
  $ aslref Rrxqb.asl
  File Rrxqb.asl, line 6, characters 22 to 39:
  ASL Error: Undefined identifier: 'println'
  [1]

Test Rzyvw.asl:
  $ aslref Rzyvw.asl
  File Rzyvw.asl, line 7, characters 22 to 39:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rzyvw.asl
  // CHECK: Otherwise

Test Ikfyg.asl:
  $ aslref Ikfyg.asl
  File Ikfyg.asl, line 6, characters 13 to 14:
  ASL Error: Cannot parse.
  [1]

Test Iydbr.asl:
  $ aslref Iydbr.asl
  File Iydbr.asl, line 7, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer {10}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iydbr.asl
  // CHECK-NOT: 5

Test Rjqxc.asl:
  $ aslref Rjqxc.asl
  File Rjqxc.asl, line 7, characters 8 to 23:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rjqxc.asl
  // CHECK-NOT: Run

Test Rkldr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rkldr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rlsvv.asl:
  $ aslref Rlsvv.asl
  File Rlsvv.asl, line 16, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer {1..10}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rlsvv.asl
  // CHECK: 1
  // CHECK-NEXT: 2
  // CHECK-NEXT: 3
  // CHECK-NEXT: 4
  // CHECK-NEXT: 5
  // CHECK-NEXT: 6
  // CHECK-NEXT: 7
  // CHECK-NEXT: 8
  // CHECK-NEXT: 9
  // CHECK-NEXT: 10

Test Rmhpw.asl:
  $ aslref Rmhpw.asl
  File Rmhpw.asl, line 11, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rmhpw.asl
  // CHECK: 1
  // CHECK_NEXT: 2
  // CHECK_NEXT: 4
  // CHECK_NEXT: 8

Test Rnpwr.asl:
  $ aslref Rnpwr.asl
  File Rnpwr.asl, line 18, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rnpwr.asl
  // CHECK: 0
  // CHECK-NEXT: 1
  // CHECK-NEXT: 2
  // CHECK-NEXT: 3
  // CHECK-NEXT: 4
  // CHECK-NEXT: 5
  // CHECK-NEXT: 6
  // CHECK-NEXT: 7
  // CHECK-NEXT: 8
  // CHECK-NEXT: 9
  // CHECK-NEXT: 10

Test Rnzgh.asl:
  $ aslref Rnzgh.asl

Test Rrqng.asl:
  $ aslref Rrqng.asl
  File Rrqng.asl, line 6, characters 8 to 9:
  ASL Typing error: cannot assign to immutable storage "x".
  [1]

Test Rssbd.asl:
  $ aslref Rssbd.asl
  File Rssbd.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rssbd.asl
  // CHECK: 10

Test Rwvqt.asl:
  $ aslref Rwvqt.asl
  File Rwvqt.asl, line 8, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rwvqt.asl
  // CHECK-NOT: 1

Test Rytnr.asl:
  $ aslref Rytnr.asl

Test Rzsnd.asl:
  $ aslref Rzsnd.asl
  File Rzsnd.asl, line 10, characters 22 to 23:
  ASL Error: Cannot parse.
  [1]

Test Icgrh.asl:
  $ aslref Icgrh.asl

Test Itcst.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Itcst.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Iyjbb.asl:
  $ aslref Iyjbb.asl

Test Ivqlx.asl:
  $ aslref Ivqlx.asl

Test Rpzzj.asl:
  $ aslref Rpzzj.asl

Test Rycpx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rycpx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ibhln.asl:
  $ aslref Ibhln.asl
  File Ibhln.asl, line 8, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

Test Igjzq.asl:
  $ aslref Igjzq.asl

Test Igqrd.asl:
  $ aslref Igqrd.asl

Test Imkpr.asl:
  $ aslref Imkpr.asl
  File Imkpr.asl, line 27, characters 38 to 39:
  ASL Error: Cannot parse.
  [1]

Test Iszvf.asl:
  $ aslref Iszvf.asl
  File Iszvf.asl, line 7, characters 22 to 23:
  ASL Error: Cannot parse.
  [1]

Test Ixvbg.asl:
  $ aslref Ixvbg.asl

Test Rgyjz.asl:
  $ aslref Rgyjz.asl
  File Rgyjz.asl, line 6, characters 22 to 23:
  ASL Error: Cannot parse.
  [1]

Test Igqyg.asl:
  $ aslref Igqyg.asl
  File Igqyg.asl, line 5, characters 27 to 28:
  ASL Error: Cannot parse.
  [1]

Test Rxnbn.asl:
  $ aslref Rxnbn.asl

Test Xxswl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Xxswl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Isbck.asl:
  $ aslref Isbck.asl

Test Gmtxx.asl:
  $ aslref Gmtxx.asl
  File Gmtxx.asl, line 6, characters 4 to 27:
  ASL Typing error: a subtype of integer {11} was expected,
    provided integer {0..10}.
  [1]

Test Ikjdr.asl:
  $ aslref Ikjdr.asl

Test Dgwxk.asl:
  $ aslref Dgwxk.asl

Test Dvmzx.asl:
  $ aslref Dvmzx.asl

Test Dfxqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dfxqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dbmgm.asl:
  $ aslref Dbmgm.asl
  File Dbmgm.asl, line 8, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

Test Ikrll.asl:
  $ aslref Ikrll.asl

Test Rvbll.asl:
  $ aslref Rvbll.asl

Test Rwzvx.asl:
  $ aslref Rwzvx.asl
  File Rwzvx.asl, line 6, characters 12 to 13:
  ASL Execution error: Mismatch type:
    value 4 does not belong to type integer {0..3}.
  [1]

Test Igysk.asl:
  $ aslref Igysk.asl
  File Igysk.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Ihswr.asl:
  $ aslref Ihswr.asl
  File Ihswr.asl, line 11, characters 4 to 15:
  ASL Typing error: a subtype of bits(4) was expected, provided bits(2).
  [1]

Test Iknxj.asl:
  $ aslref Iknxj.asl
  File Iknxj.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Ikxsd.asl:
  $ aslref Ikxsd.asl
  File Ikxsd.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Itwtz.asl:
  $ aslref Itwtz.asl
  File Itwtz.asl, line 6, characters 4 to 23:
  ASL Typing error: a subtype of bits(4) was expected, provided bits(2).
  [1]

Test Imhyb.asl:
  $ aslref Imhyb.asl

Test Isjdc.asl:
  $ aslref Isjdc.asl

Test Inlfd.asl:
  $ aslref Inlfd.asl

Test Rfmxk.asl:
  $ aslref Rfmxk.asl

Test Dvpzz.asl:
  $ aslref Dvpzz.asl

Test Ipqct.asl:
  $ aslref Ipqct.asl

Test Iwzkm.asl:
  $ aslref Iwzkm.asl

Test Dbtbr.asl:
  $ aslref Dbtbr.asl
  File Dbtbr.asl, line 11, character 0 to line 14, character 3:
  ASL Typing error: cannot declare already declared element "testa".
  [1]

Test Ifsfq.asl:
  $ aslref Ifsfq.asl
  File Ifsfq.asl, line 11, character 0 to line 14, character 3:
  ASL Typing error: cannot declare already declared element "testa".
  [1]

Test Ipfgq.asl:
  $ aslref Ipfgq.asl
  File Ipfgq.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

Test Isctb.asl:
  $ aslref Isctb.asl
  File Isctb.asl, line 19, character 0 to line 22, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

Test Rpgfc.asl:
  $ aslref Rpgfc.asl
  File Rpgfc.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

Test Dhbcp.asl:
  $ aslref Dhbcp.asl

Output is non-deterministic
$ bash run.sh aslref Idfml.asl
Fatal error: exception Stack overflow
[2]

Test Ismmh.asl:
  $ aslref Ismmh.asl

Test Rfwqm.asl:
  $ aslref Rfwqm.asl
  File Rfwqm.asl, line 3, characters 18 to 19:
  ASL Error: Undefined identifier: 'b'
  [1]

Test Rhwtv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rhwtv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rjbxq.asl:
  $ aslref Rjbxq.asl
  File Rjbxq.asl, line 13, characters 16 to 17:
  ASL Error: Undefined identifier: 'b'
  [1]

Test Rschv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rschv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rvdpc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rvdpc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ryspm.asl:
  $ aslref Ryspm.asl

Test Rftpk.asl:
  $ aslref Rftpk.asl

Test Rftvn.asl:
  $ aslref Rftvn.asl
  File Rftvn.asl, line 7, characters 10 to 12:
  ASL Typing error: a subtype of boolean was expected, provided integer {10}.
  [1]

Test Rjqyf.asl:
  $ aslref Rjqyf.asl
  File Rjqyf.asl, line 5, characters 4 to 15:
  ASL Typing error: a subtype of boolean was expected, provided integer {10}.
  [1]

Test Rnbdj.asl:
  $ aslref Rnbdj.asl
  File Rnbdj.asl, line 5, characters 7 to 9:
  ASL Typing error: a subtype of boolean was expected, provided integer {10}.
  [1]

Test Rnxrc.asl:
  $ aslref Rnxrc.asl
  File Rnxrc.asl, line 5, characters 4 to 13:
  ASL Typing error: a subtype of exception {  } was expected,
    provided integer {10}.
  [1]

Test Rsdjk.asl:
  $ aslref Rsdjk.asl
  File Rsdjk.asl, line 8, characters 13 to 15:
  ASL Error: Cannot parse.
  [1]

Test Rvtjw.asl:
  $ aslref Rvtjw.asl
  File Rvtjw.asl, line 5, character 4 to line 7, character 7:
  ASL Typing error: a subtype of integer was expected, provided real.
  [1]

Test Rwgsy.asl:
  $ aslref Rwgsy.asl

Test Rwvxs.asl:
  $ aslref Rwvxs.asl

Test Idgwj.asl:
  $ aslref Idgwj.asl
  File Idgwj.asl, line 9, characters 4 to 19:
  ASL Typing error: a subtype of b was expected, provided a.
  [1]

Test Ikkcc.asl:
  $ aslref Ikkcc.asl

Test Immkf.asl:
  $ aslref Immkf.asl
  File Immkf.asl, line 7, characters 4 to 5:
  ASL Typing error: a subtype of integer {0..N} was expected,
    provided integer {0..M}.
  [1]

Test Iyyqx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Iyyqx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rgnts.asl:
  $ aslref Rgnts.asl
  File Rgnts.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Rlxqz.asl:
  $ aslref Rlxqz.asl
  File Rlxqz.asl, line 5, characters 4 to 25:
  ASL Typing error: a subtype of integer was expected, provided real.
  [1]

Test Rwmfv.asl:
  $ aslref Rwmfv.asl

Test Rzcvd.asl:
  $ aslref Rzcvd.asl
  File Rzcvd.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Iryrp.asl:
  $ aslref Iryrp.asl

Test Rzjky.asl:
  $ aslref Rzjky.asl

Test Djrxm.asl:
  $ aslref Djrxm.asl

Test Iztmq.asl:
  $ aslref Iztmq.asl

Test Iblvp.asl:
  $ aslref Iblvp.asl
  File Iblvp.asl, line 3, character 0 to line 6, character 3:
  ASL Typing error: cannot declare already declared element "N".
  [1]

Test Ibzvb.asl:
  $ aslref Ibzvb.asl

Test Ilfjz.asl:
  $ aslref Ilfjz.asl

Test Ipdkt.asl:
  $ aslref Ipdkt.asl
  File Ipdkt.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Irkbv.asl:
  $ aslref Irkbv.asl
  File Irkbv.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Irqqb.asl:
  $ aslref Irqqb.asl

Test Itqgh.asl:
  $ aslref Itqgh.asl

Test Izlzc.asl:
  $ aslref Izlzc.asl

Test Rlvth.asl:
  $ aslref Rlvth.asl
  File Rlvth.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Rrhtn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rrhtn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rtjkq.asl:
  $ aslref Rtjkq.asl
  File Rtjkq.asl, line 5, characters 4 to 39:
  ASL Typing error: a subtype of integer {32, 64} was expected,
    provided integer.
  [1]

Test Dcfyp.asl:
  $ aslref Dcfyp.asl

Test Dljlw.asl:
  $ aslref Dljlw.asl

Test Dmfbc.asl:
  $ aslref Dmfbc.asl

Test Dpmbl.asl:
  $ aslref Dpmbl.asl

Test Dtrfw.asl:
  $ aslref Dtrfw.asl

Test Dvxkm.asl:
  $ aslref Dvxkm.asl

Test Ibtmt.asl:
  $ aslref Ibtmt.asl
  File Ibtmt.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "test".
  [1]

Test Icmlp.asl:
  $ aslref Icmlp.asl

Test Iflkf.asl:
  $ aslref Iflkf.asl
  File Iflkf.asl, line 10, characters 4 to 20:
  ASL Typing error: a subtype of bits(2) was expected, provided bits(1).
  [1]

Test Iktjn.asl:
  $ aslref Iktjn.asl
  File Iktjn.asl, line 21, characters 4 to 6:
  ASL Typing error: a subtype of bits(N) was expected, provided bits(wid).
  [1]

Test Isbwr.asl:
  $ aslref Isbwr.asl
  File Isbwr.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Ivfdp.asl:
  $ aslref Ivfdp.asl

Test Iymhx.asl:
  $ aslref Iymhx.asl

Test Rbqjg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rbqjg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rccvd.asl:
  $ aslref Rccvd.asl

Test Rkmbd.asl:
  $ aslref Rkmbd.asl

Test Rmwbn.asl:
  $ aslref Rmwbn.asl
  File Rmwbn.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

Test Rpfwq.asl:
  $ aslref Rpfwq.asl

Test Rqybh.asl:
  $ aslref Rqybh.asl

Test Rrtcf.asl:
  $ aslref Rrtcf.asl
  File Rrtcf.asl, line 10, characters 4 to 13:
  ASL Error: Arity error while calling 'test':
    0 arguments expected and 1 provided
  [1]

Test Rtcdl.asl:
  $ aslref Rtcdl.asl

Test Rtzsp.asl:
  $ aslref Rtzsp.asl
  File Rtzsp.asl, line 10, characters 4 to 12:
  ASL Error: Undefined identifier: 'test2'
  [1]

Test Rzlwd.asl:
  $ aslref Rzlwd.asl

Test Rbknt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rbknt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rjgwf.asl:
  $ aslref Rjgwf.asl

Test Rttgq.asl:
  $ aslref Rttgq.asl
  File Rttgq.asl, line 10, characters 12 to 21:
  ASL Typing error: Illegal application of operator || on types a and integer
  [1]

Test Ivmzf.asl:
  $ aslref Ivmzf.asl

Test Iyhml.asl:
  $ aslref Iyhml.asl
  File Iyhml.asl, line 5, characters 4 to 34:
  ASL Typing error: a subtype of integer {0..70} was expected,
    provided integer.
  [1]

Test Iyhrp.asl:
  $ aslref Iyhrp.asl
  File Iyhrp.asl, line 5, characters 12 to 19:
  ASL Typing error: Illegal application of operator DIV on types integer {2, 4}
    and integer {(- 1)..1}
  [1]

Test Iyxsy.asl:
  $ aslref Iyxsy.asl

Test Rbzkw.asl:
  $ aslref Rbzkw.asl
  File Rbzkw.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Rkfys.asl:
  $ aslref Rkfys.asl

Test Rzywy.asl:
  $ aslref Rzywy.asl

Test Ilghj.asl:
  $ aslref Ilghj.asl
  File Ilghj.asl, line 6, characters 18 to 20:
  ASL Error: Cannot parse.
  [1]

Test Rkxmr.asl:
  $ aslref Rkxmr.asl
  File Rkxmr.asl, line 6, characters 15 to 21:
  ASL Typing error: Illegal application of operator == on types bits(M)
    and bits(8)
  [1]

Test Rxzvt.asl:
  $ aslref Rxzvt.asl

Test Rmrht.asl:
  $ aslref Rmrht.asl
  File Rmrht.asl, line 7, characters 12 to 18:
  ASL Typing error: Illegal application of operator == on types bits(1)
    and bits(11)
  [1]

Test Rsqxn.asl:
  $ aslref Rsqxn.asl

Test Rkczs.asl:
  $ aslref Rkczs.asl

Test Rnynk.asl:
  $ aslref Rnynk.asl

Test Rfhyz.asl:
  $ aslref Rfhyz.asl
  File Rfhyz.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

Test Rvbmx.asl:
  $ aslref Rvbmx.asl

Test Rxvwk.asl:
  $ aslref Rxvwk.asl

Test Imjwm.asl:
  $ aslref Imjwm.asl

Test Ildnp.asl:
  $ aslref Ildnp.asl

Test Dcwvh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dcwvh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dhlqc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dhlqc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dyydw.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dyydw.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ilzcx.asl:
  $ aslref Ilzcx.asl
  File Ilzcx.asl, line 4, characters 32 to 37:
  ASL Error: Undefined identifier: 'add'
  [1]

Test Ipkxk.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ipkxk.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ilhlr.asl:
  $ aslref Ilhlr.asl

Test Rrfqp.asl:
  $ aslref Rrfqp.asl

Test Rvnkt.asl:
  $ aslref Rvnkt.asl
  ASL Execution error: Illegal application of operator DIV for values 10 and 4.
  [1]

Test Dfxst.asl:
  $ aslref Dfxst.asl

Test Rwdgq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Rwdgq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Rzdkc.asl:
  $ aslref Rzdkc.asl
  File Rzdkc.asl, line 3, characters 15 to 16:
  ASL Error: Cannot parse.
  [1]

Test Dccty.asl:
  $ aslref Dccty.asl

Test Dcsft.asl:
  $ aslref Dcsft.asl

Test Ihybt.asl:
  $ aslref Ihybt.asl

Test Ilykd.asl:
  $ aslref Ilykd.asl

Test Inxjr.asl:
  $ aslref Inxjr.asl

Test Dkckx.asl:
  $ aslref Dkckx.asl

Test Dqnhm.asl:
  $ aslref Dqnhm.asl

Test Imszt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Imszt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Intyz.asl:
  $ aslref Intyz.asl

Test Izpwm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Izpwm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dzpmf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dzpmf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ixykc.asl:
  $ aslref Ixykc.asl

Test Dxrbt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Dxrbt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Ixsfy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ixsfy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Djljd.asl:
  $ aslref Djljd.asl
  File Djljd.asl, line 3, characters 27 to 28:
  ASL Error: Cannot parse.
  [1]

Test Iwvgg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Iwvgg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Dmtqj.asl:
  $ aslref Dmtqj.asl

Test Ikkqy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Ikkqy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

Test Iybgl.asl:
  $ aslref Iybgl.asl

Test Igfzt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false:
  $ aslref Igfzt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Igfzt.asl, line 21, characters 13 to 28:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Igfzt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  // CHECK: TRUE
  [1]

Test Iqjtn_a.asl:
  $ aslref Iqjtn_a.asl

Test Iqjtn_b.asl:
  $ aslref Iqjtn_b.asl

Test Iqjtn_c.asl:
  $ aslref Iqjtn_c.asl
  Uncaught exception: exc {err_code: 0}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iqjtn_c.asl
  // CHECK-NOT: Exception

Test Iqjtn_d.asl:
  $ aslref Iqjtn_d.asl
  Uncaught exception: exc {err_code: 0}
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iqjtn_d.asl
  // CHECK-NOT: Exception

Test Iqrxp.asl:
  $ aslref Iqrxp.asl
  File Iqrxp.asl, line 10, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Iqrxp.asl
  // CHECK: HELLO
  // CHECK-NEXT: WORLD
  // CHECK-NEXT: HELLO
  // CHECK-NEXT: HELLO
  // CHECK-NEXT: WORLD

Test Rxkgc.asl:
  $ aslref Rxkgc.asl

Test Rgqnl.asl:
  $ aslref Rgqnl.asl
  File Rgqnl.asl, line 21, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rgqnl.asl
  // CHECK: TRUE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: FALSE
  // CHECK-NEXT: TRUE
  // CHECK-NEXT: Hello
  // CHECK-NEXT: World
  // CHECK-NEXT: FALSE
  // CHECK-NEXT: World
  // CHECK-NEXT: TRUE

Test Rlrhd.asl:
  $ aslref Rlrhd.asl
  File Rlrhd.asl, line 10, characters 13 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rlrhd.asl
  // CHECK: TRUE
  // CHECK-NEXT: FALSE
  // CHECK-NEXT: FALSE
  // CHECK-NEXT: TRUE

Test Rbncy.asl:
  $ aslref Rbncy.asl
  File Rbncy.asl, line 7, characters 17 to 32:
  ASL Error: Undefined identifier: 'exp_real'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rbncy.asl
  // CHECK: 1000
  // CHECK-NEXT: 32

Test Inbct.asl:
  $ aslref Inbct.asl

Test Rcrqj.asl:
  $ aslref Rcrqj.asl
  File Rcrqj.asl, line 6, characters 21 to 35:
  ASL Error: Undefined identifier: 'div_int'
  [1]

Test Rghxr_a.asl:
  $ aslref Rghxr_a.asl
  File Rghxr_a.asl, line 7, characters 18 to 32:
  ASL Error: Undefined identifier: 'frem_int'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rghxr_a.asl
  // CHECK: 0
  // CHECK-NEXT: 1

Test Rghxr_b.asl:
  $ aslref Rghxr_b.asl
  File Rghxr_b.asl, line 5, characters 18 to 33:
  ASL Error: Undefined identifier: 'frem_int'
  [1]

Test Rncwm.asl:
  $ aslref Rncwm.asl
  File Rncwm.asl, line 7, characters 17 to 31:
  ASL Error: Undefined identifier: 'exp_int'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rncwm.asl
  // CHECK: 1000
  // CHECK-NEXT: 32

Test Rsvmm.asl:
  $ aslref Rsvmm.asl
  File Rsvmm.asl, line 7, characters 18 to 32:
  ASL Error: Undefined identifier: 'fdiv_int'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rsvmm.asl
  // CHECK: 2
  // CHECK-NEXT: -2

Test Rthsv.asl:
  $ aslref Rthsv.asl
  File Rthsv.asl, line 6, characters 17 to 39:
  ASL Error: Undefined identifier: 'shiftleft_int'
  [1]

Test Rvgzf.asl:
  $ aslref Rvgzf.asl
  File Rvgzf.asl, line 9, characters 17 to 37:
  ASL Error: Undefined identifier: 'shiftleft_int'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rvgzf.asl
  // CHECK: 80
  // CHECK-NEXT: 96
  // CHECK-NEXT: 3
  // CHECK-NEXT: 6

Test Rwwtv_a.asl:
  $ aslref Rwwtv_a.asl
  File Rwwtv_a.asl, line 5, characters 18 to 32:
  ASL Error: Undefined identifier: 'div_int'
  [1]

Test Rwwtv_b.asl:
  $ aslref Rwwtv_b.asl
  File Rwwtv_b.asl, line 5, characters 18 to 32:
  ASL Error: Undefined identifier: 'fdiv_int'
  [1]

Test Rztjn_a.asl:
  $ aslref Rztjn_a.asl
  File Rztjn_a.asl, line 7, characters 18 to 31:
  ASL Error: Undefined identifier: 'div_int'
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rztjn_a.asl
  // CHECK: 2
  // CHECK-NEXT: -2

Test Rztjn_b.asl:
  $ aslref Rztjn_b.asl
  File Rztjn_b.asl, line 5, characters 18 to 31:
  ASL Error: Undefined identifier: 'div_int'
  [1]

Test Rbrcm.asl:
  $ aslref Rbrcm.asl
  File Rbrcm.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rbrcm.asl
  // CHECK: TRUE

Test Rrxyn.asl:
  $ aslref Rrxyn.asl
  File Rrxyn.asl, line 9, characters 13 to 25:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]
For reference, the test writter intention was that this output matched:
  $ get_expected_output Rrxyn.asl
  // CHECK: 240
  // CHECK-NEXT: -16

Test Rdgbm.asl:
  $ aslref Rdgbm.asl

