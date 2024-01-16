  $ aslref Imhys.asl
  File Imhys.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

  $ aslref Iwxgp.asl
  File Iwxgp.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

  $ aslref Rdpzk.asl
  File Rdpzk.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

  $ aslref Rirnq.asl
  File Rirnq.asl, line 6, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

  $ aslref Rmhfw.asl
  File Rmhfw.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

  $ aslref Rvddg.asl
  File Rvddg.asl, line 5, characters 4 to 18:
  ASL Error: Undefined identifier: 'Unreachable'
  [1]

  $ aslref Ibklj.asl

  $ aslref Icxps.asl
  Hello world

Several tests are piped through sed to remove absoute paths in output
  $ aslref Rbsqr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rchth.asl
  [1]

  $ aslref Rjwph.asl
  File Rjwph.asl, line 6, characters 4 to 27:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rxnsk.asl
  File Rxnsk.asl, line 8, characters 10 to 11:
  ASL Error: Undefined identifier: 'a'
  [1]

  $ aslref Dgvbk.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Inxkd.asl

  $ aslref Rfrwd.asl

  $ aslref Rswqd.asl

  $ aslref Ihjcd.asl
  1000000
  1000000

  $ aslref Ipbpq.asl
  File Ipbpq.asl, line 8, characters 13 to 32:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Iqczx.asl
  File Iqczx.asl, line 7, characters 13 to 39:
  ASL Typing error: Illegal application of operator + on types string
    and bits(16)
  [1]

  $ aslref Rhyfh.asl
  File Rhyfh.asl, line 11, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer {10}
  [1]

  $ aslref Rmxps.asl
  File Rmxps.asl, line 7, characters 13 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Rpbfk.asl
  File Rpbfk.asl, line 8, characters 13 to 24:
  ASL Typing error: Illegal application of operator + on types string
    and bits(4)
  [1]

  $ aslref Rqqbb.asl
  File Rqqbb.asl, line 11, characters 13 to 22:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]

  $ aslref Rrymd.asl

  $ aslref Rzrvy.asl
  File Rzrvy.asl, line 10, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Ihvlx.asl

  $ aslref Iscly.asl
  File Iscly.asl, line 5, characters 8 to 12:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rhprd.asl

  $ aslref Rjgrk.asl

  $ aslref Rqmdm.asl

  $ aslref Rgfsh.asl
  File Rgfsh.asl, line 5, characters 11 to 17:
  ASL Error: Undefined identifier: 'String'
  [1]

  $ aslref Ddpxj.asl

  $ aslref Ipgss.asl
  File Ipgss.asl, line 8, characters 13 to 22:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rdgjt.asl

  $ aslref Rhhcd.asl
  File Rhhcd.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rjjcj.asl

  $ aslref Rpxrr.asl

  $ aslref Rwgvr.asl
  File Rwgvr.asl, line 7, characters 13 to 22:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Ryhnv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ihmrk.asl
  File Ihmrk.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Imqwb.asl

  $ aslref Rcgwr.asl

  $ aslref Rjhkl.asl
  File Rjhkl.asl, line 6, characters 4 to 5:
  ASL Typing error: integer {10} does not subtype any of: bits(-), record {  },
    exception {  }.
  [1]

  $ aslref Rqwsq.asl
  File Rqwsq.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rtvpr.asl

  $ aslref Dwgqs.asl

  $ aslref Itfps.asl

  $ aslref Rdlxv.asl
  File Rdlxv.asl, line 14, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rdxwn.asl

  $ aslref Rmbrm.asl
  File Rmbrm.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rmdzd.asl
  File Rmdzd.asl, line 3, character 0 to line 6, character 2:
  ASL Typing error: cannot declare already declared element "b".
  [1]

  $ aslref Rwfmf.asl

  $ aslref Dqxyc.asl

  $ aslref Ihlbl.asl

  $ aslref Rbwdx.asl
  File Rbwdx.asl, line 23, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rchkr.asl
  File Rchkr.asl, line 3, character 0 to line 6, character 2:
  ASL Typing error: cannot declare already declared element "b".
  [1]

  $ aslref Rkgxl.asl

  $ aslref Rmghv.asl

  $ aslref Rsvjb.asl
  File Rsvjb.asl, line 12, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rmhwm.asl

  $ aslref Dknbd.asl

  $ aslref Dnzwt.asl

  $ aslref Dpqck.asl

  $ aslref Rgvzk.asl

  $ aslref Rgrvj.asl
  Fatal error: exception Not_found
  [2]

  $ aslref Gpfrq.asl

  $ aslref Dztpp.asl

  $ aslref Dzxss.asl

  $ aslref Ighgk.asl
  File Ighgk.asl, line 3, characters 34 to 35:
  ASL Error: Cannot parse.
  [1]

  $ aslref Izddj.asl
  File Izddj.asl, line 3, characters 34 to 35:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rbsmk.asl

  $ aslref Rcztx.asl

  $ aslref Rgwcp.asl

  $ aslref Rhjpn.asl

  $ aslref Rlsnp.asl

  $ aslref Rtphr.asl
  File Rtphr.asl, line 3, characters 34 to 35:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rwjyh.asl

  $ aslref Ibbqr.asl

  $ aslref Icdvy.asl
  File Icdvy.asl, line 3, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ikfcr.asl
  File Ikfcr.asl, line 3, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iwbwl.asl

  $ aslref Iwlpj.asl

  $ aslref Rfwmm.asl

  $ aslref Rlyds.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rrlqp.asl

  $ aslref Rsvdj.asl

  $ aslref Rtznr.asl
  File Rtznr.asl, line 3, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iwvqz.asl

  $ aslref Rcftd.asl
  File Rcftd.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {4..10}
  [1]

  $ aslref Rnjdz.asl
  File Rnjdz.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rqggh.asl

  $ aslref Ihjbh.asl
  File Ihjbh.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Dcqxl.asl
  File Dcqxl.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]

  $ aslref Ijqpk.asl
  File Ijqpk.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]

  $ aslref Iwjcl.asl
  File Iwjcl.asl, line 11, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Iyftf.asl

  $ aslref Rgycg.asl
  File Rgycg.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]

  $ aslref Rxcjd.asl
  File Rxcjd.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string and real
  [1]

  $ aslref Idmnl.asl
  File Idmnl.asl, line 8, characters 13 to 32:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Rwkcy.asl
  File Rwkcy.asl, line 7, characters 4 to 15:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Dyzbq.asl

  $ aslref Imzxl.asl

  $ aslref Iprpy.asl
  File Iprpy.asl, line 8, characters 21 to 27:
  ASL Typing error: Illegal application of operator <= on types enum and enum
  [1]

  $ aslref Iqmwt.asl

  $ aslref Rdwsp.asl
  File Rdwsp.asl, line 3, characters 0 to 31:
  ASL Typing error: cannot declare already declared element "A".
  [1]

  $ aslref Rhjyj.asl

  $ aslref Rlccn.asl
  File Rlccn.asl, line 8, characters 13 to 26:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Rcpck.asl
  File Rcpck.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Dbvgk.asl
  File Dbvgk.asl, line 3, characters 33 to 34:
  ASL Error: Cannot parse.
  [1]

  $ aslref Dcbqk.asl

  $ aslref Dnrwc.asl

  $ aslref Dwszm.asl

  $ aslref Imrhk.asl

  $ aslref Iybhf.asl

  $ aslref Rfzsd.asl
  File Rfzsd.asl, line 3, characters 15 to 16:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rljbg.asl
  File Rljbg.asl, line 3, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rnfbn.asl
  File Rnfbn.asl, line 5, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rqyzd.asl
  File Rqyzd.asl, line 5, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

  $ aslref Igqmv.asl
  File Igqmv.asl, line 3, characters 15 to 33:
  ASL Error: Unsupported expression 4 as integer {4, 8}.
  [1]

  $ aslref Ijskw.asl

  $ aslref Rghrp.asl
  ASL Error: Undefined identifier: 'a'
  [1]

  $ aslref Rncnq.asl
  File Rncnq.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rqzjs.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rskrk.asl
  ASL Error: Undefined identifier: 'a'
  [1]

  $ aslref Iqfzh.asl
  File Iqfzh.asl, line 7, characters 13 to 29:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Irxlg.asl
  File Irxlg.asl, line 16, characters 13 to 26:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Isqvv.asl

  $ aslref Ivmkf.asl
  File Ivmkf.asl, line 7, characters 13 to 31:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Ivpst.asl
  File Ivpst.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rdhzt.asl

  $ aslref Rdkgq.asl

  $ aslref Rpmqb.asl

  $ aslref Rqxgw.asl
  File Rqxgw.asl, line 7, characters 14 to 15:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rzrwh.asl

  $ aslref Rzvpt.asl
  File Rzvpt.asl, line 7, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and bits(32)
  [1]

  $ aslref Rzwgh.asl

  $ aslref Iglwm.asl
  File Iglwm.asl, line 5, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

  $ aslref Imtwl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Itzvj_a.asl
  File Itzvj_a.asl, line 3, characters 23 to 30:
  ASL Error: Cannot parse.
  [1]

  $ aslref Itzvj_b.asl

  $ aslref Rvczx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rvczx.asl, line 3, characters 15 to 16:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ieoax.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Inhxt.asl

  $ aslref Icgyh.asl

  $ aslref Ifpvz.asl
  File Ifpvz.asl, line 3, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iqnsd.asl
  File Iqnsd.asl, line 16, characters 20 to 21:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ibghb.asl

  $ aslref Ifzms.asl

  $ aslref Ijdcc.asl
  File Ijdcc.asl, line 3, character 0 to line 5, character 2:
  ASL Typing error: Cannot extract from bitvector of length 5 slices 10:7.
  [1]

  $ aslref Ikgmc.asl

  $ aslref Ikpbx.asl

  $ aslref Iqdhp.asl

  $ aslref Rbdjk.asl
  File Rbdjk.asl, line 3, character 0 to line 5, character 2:
  ASL Typing error: overlapping slices 1:3.
  [1]

  $ aslref Rcgdg.asl

  $ aslref Rchbw.asl

  $ aslref Rcnhb.asl
  File Rcnhb.asl, line 3, character 0 to line 5, character 2:
  ASL Typing error: overlapping slices 3:0, 3:1.
  [1]

  $ aslref Rgqvz.asl
  File Rgqvz.asl, line 17, characters 13 to 43:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Rlghs.asl
  File Rlghs.asl, line 4, characters 4 to 5:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rmpmg.asl
  File Rmpmg.asl, line 3, character 0 to line 6, character 2:
  ASL Typing error: cannot declare already declared element "aa".
  [1]

  $ aslref Rmxyq.asl

  $ aslref Rqcym.asl

  $ aslref Rrmtq.asl

  $ aslref Ryypn.asl
  File Ryypn.asl, line 5, characters 27 to 28:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rzjsh.asl

  $ aslref Dwxqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Iscbx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Uxknl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ibyvl.asl
  File Ibyvl.asl, line 9, characters 0 to 3:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ijrdl.asl

  $ aslref Iwykz.asl

  $ aslref Ihjrd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ihjrd.asl, line 16, characters 0 to 14:
  ASL Typing error: multiple recursive declarations: "a", "a", "a"
  [1]

  $ aslref Ilwqq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Imvnz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rdhrc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rswvp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ihsww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ihsww.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

Output is non-deterministic
$ aslref Ijvrm.asl
Segmentation fault (core dumped)
[139]

  $ aslref Ikgks.asl

  $ aslref Imtml.asl

  $ aslref Rhqzy.asl

  $ aslref Rlpdl.asl
  File Rlpdl.asl, line 3, characters 0 to 29:
  ASL Error: Undefined identifier: 'a'
  [1]

  $ aslref Rnxrx.asl

  $ aslref Rsrhn.asl
  File Rsrhn.asl, line 4, characters 0 to 28:
  ASL Typing error: a subtype of a was expected, provided string.
  [1]

  $ aslref Rzrkm.asl

  $ aslref Rzwhp.asl

  $ aslref Rkdks.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

# Output is non-deterministic
$ aslref Rybwy.asl
Segmentation fault (core dumped)
[139]

  $ aslref Iglhk.asl

  $ aslref Ivylk.asl
  File Ivylk.asl, line 3, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rckgp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rdjmc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rdlxt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rfkgp.asl
  File Rfkgp.asl, line 5, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rfpmt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rfpmt.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rgbnc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rgbnc.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rplyx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rprzn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rprzn.asl, line 5, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rrzll.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ivqhq.asl

  $ aslref Iypxd.asl
  File Iypxd.asl, line 3, characters 4 to 5:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rbhmy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rdbzz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rksqp_a.asl
  File Rksqp_a.asl, line 3, characters 14 to 15:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rksqp_b.asl
  File Rksqp_b.asl, line 3, characters 19 to 20:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rksqp_c.asl
  File Rksqp_c.asl, line 3, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rpnqj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rsblx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rtrdj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rwzjq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rznth.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dgwwp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ibcww.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ifyfn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ifyfn.asl, line 10, characters 4 to 27:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rsfpm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rsfpm.asl, line 12, characters 4 to 27:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rfrdx.asl

  $ aslref Rjgvx.asl

  $ aslref Rrxhx.asl

  $ aslref Dbhpj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dmryb.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ifbvh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Iqjnf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Iwhlv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rlcsz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rmbzp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rmzjj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rnctb.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rqkxv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rtjrh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rtjrh.asl, line 3, characters 0 to 16:
  ASL Typing error: multiple recursive declarations: "_a", "_a"
  [1]

  $ aslref Djwkg.asl

  $ aslref Djwxx.asl

  $ aslref Dqmyp.asl

  $ aslref Dvftv.asl

  $ aslref Idvsm.asl

  $ aslref Igklw.asl
  ASL Error: Arity error while calling 'main':
    1 arguments expected and 0 provided
  [1]

  $ aslref Ipfng.asl

  $ aslref Itwjf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Itwjf.asl, line 8, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rdfwz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rhdgv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rhdgv.asl, line 3, characters 0 to 15:
  ASL Typing error: multiple recursive declarations: "a", "a"
  [1]

  $ aslref Rjbxs.asl

  $ aslref Rkcmk.asl
  File Rkcmk.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

  $ aslref Rkfgj.asl

  $ aslref Rptdd.asl

  $ aslref Rqcvm.asl

  $ aslref Rwkhc_a.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rwkhc_b.asl
  File Rwkhc_b.asl, line 6, characters 0 to 3:
  ASL Error: Cannot parse.
  [1]

  $ aslref Dnmfp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Itsxl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Itsxl.asl, line 9, characters 18 to 25:
  ASL Typing error: (integer {10}, integer {20}) does not subtype any of:
    bits(-), record {  }, exception {  }.
  [1]

  $ aslref Ixfpv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ixfpv.asl, line 9, characters 12 to 19:
  ASL Typing error: (integer {10}, integer {20}) does not subtype any of:
    bits(-), record {  }, exception {  }.
  [1]

  $ aslref Rjpvl.asl
  File Rjpvl.asl, line 13, characters 4 to 5:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rkvnx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rkvnx.asl, line 7, characters 4 to 5:
  ASL Typing error: integer {4} does not subtype any of: bits(-), record {  },
    exception {  }.
  [1]

  $ aslref Isbfk.asl

  $ aslref Rhdds.asl

  $ aslref Rpblf.asl

  $ aslref Igjhs.asl

  $ aslref Rwlch.asl

  $ aslref Rxbmn.asl

  $ aslref Rycdb.asl
  File Rycdb.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {10, 5}
  [1]

  $ aslref Iwlnm.asl
  File Iwlnm.asl, line 3, characters 8 to 14:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rzndl.asl

  $ aslref Rrcsd.asl
  File Rrcsd.asl, line 12, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rdyqz.asl
  File Rdyqz.asl, line 10, characters 12 to 24:
  ASL Error: Fields mismatch for creating a value of type a
    -- Passed fields are: x
  [1]

  $ aslref Rwbcq.asl

  $ aslref Rkcds.asl
  File Rkcds.asl, line 10, characters 12 to 24:
  ASL Error: Fields mismatch for creating a value of type a
    -- Passed fields are: x
  [1]

  $ aslref Rzwch.asl

  $ aslref Iqslr.asl

  $ aslref Ivgsp.asl
  File Ivgsp.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

  $ aslref Iwdmd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rlljz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rqnqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rsppt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rytky.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rzdsj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ijejd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Itfsz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rktbg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rnhgp.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rnhgp.asl, line 7, characters 4 to 18:
  ASL Typing error: a subtype of integer was expected, provided bits((b + 1)).
  [1]

  $ aslref Rsnqj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rwzcs.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  Fatal error: exception Invalid_argument("List.init")
  [1]

  $ aslref Rdvvq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rdvvq.asl, line 18, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rgxqh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rztrr.asl
  File Rztrr.asl, line 6, characters 12 to 18:
  ASL Typing error: a subtype of integer {0..(10 - 1)} was expected,
    provided integer {100}.
  [1]

  $ aslref Dkxwt.asl

  $ aslref Ihsql.asl

  $ aslref Rdgrv.asl
  File Rdgrv.asl, line 7, characters 8 to 25:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rgvcc.asl
  Uncaught exception: a {}
  [1]

  $ aslref Rtxtc.asl
  File Rtxtc.asl, line 14, characters 21 to 51:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Dggcq.asl
  File Dggcq.asl, line 15, characters 32 to 42:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Djtdg.asl
  File Djtdg.asl, line 15, characters 32 to 42:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Igzvm.asl
  File Igzvm.asl, line 17, characters 32 to 42:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rdhkh.asl
  File Rdhkh.asl, line 14, characters 23 to 25:
  ASL Typing error: cannot assign to immutable storage "aa".
  [1]

  $ aslref Rjzst.asl
  File Rjzst.asl, line 13, characters 18 to 32:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rmkgb.asl
  File Rmkgb.asl, line 17, characters 18 to 20:
  ASL Error: Undefined identifier: 'aa'
  [1]

  $ aslref Rspnm.asl
  File Rspnm.asl, line 17, characters 21 to 38:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Ryvxf.asl
  File Ryvxf.asl, line 15, characters 21 to 38:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rztlb.asl
  File Rztlb.asl, line 14, characters 22 to 35:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Iyklf.asl
  File Iyklf.asl, line 16, characters 18 to 31:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rbrcj.asl
  Uncaught exception: implicitely thrown out of a try-catch.
  [1]

  $ aslref Rgvks.asl
  File Rgvks.asl, line 15, characters 18 to 31:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rptng.asl

  $ aslref Ikbxm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Ikbxm.asl, line 5, characters 12 to 13:
  ASL Error: Undefined identifier: 'c'
  [1]

  $ aslref Rjfrd.asl
  File Rjfrd.asl, line 9, characters 12 to 13:
  ASL Error: Undefined identifier: 'a'
  [1]

  $ aslref Rlcfd.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ifkjc.asl

  $ aslref Rjnmr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rjnmr.asl, line 5, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rkszm.asl
  File Rkszm.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rtzrv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rxylp.asl
  File Rxylp.asl, line 5, characters 16 to 17:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rzxhp.asl
  File Rzxhp.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {2}
  [1]

  $ aslref Rbfwl.asl

  $ aslref Rclqj.asl

  $ aslref Rfmlk.asl

  $ aslref Rnxsf.asl

  $ aslref Rqdqd.asl
  File Rqdqd.asl, line 5, characters 13 to 14:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rsqjj.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rtfjz.asl

  $ aslref Rxhpb.asl

  $ aslref Rxsdc.asl

  $ aslref Dkcyt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Dkcyt.asl, line 10, characters 4 to 8:
  ASL Error: Mismatched use of return value from call to 'a'
  [1]

  $ aslref Dhtpl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rnywh.asl
  File Rnywh.asl, line 5, characters 4 to 14:
  ASL Typing error: cannot return something from a procedure.
  [1]

  $ aslref Rphnz.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ryyfr.asl

  $ aslref Rzhyt.asl
  File Rzhyt.asl, line 12, characters 4 to 14:
  ASL Typing error: a subtype of bits(-) was expected, provided a.
  [1]

  $ aslref Dwsxy.asl
  File Dwsxy.asl, line 9, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer {1}
  [1]

  $ aslref Icjvd.asl

  $ aslref Issxj.asl

  $ aslref Rzhvh.asl
  File Rzhvh.asl, line 5, characters 4 to 27:
  ASL Error: Arity error while calling 'tuple initialization':
    3 arguments expected and 2 provided
  [1]

  $ aslref Rydfq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Rydfq.asl, line 19, characters 13 to 20:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Dbjny.asl

  $ aslref Dqjyv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rwqrn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rwzsl.asl
  File Rwzsl.asl, line 5, characters 11 to 16:
  ASL Execution error: Assertion failed: FALSE
  [1]

  $ aslref Rkztj.asl
  File Rkztj.asl, line 7, characters 4 to 17:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rtmys.asl
  File Rtmys.asl, line 7, characters 8 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rxssl.asl
  File Rxssl.asl, line 7, characters 8 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rcwnt.asl
  File Rcwnt.asl, line 18, characters 13 to 31:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rjhst.asl
  File Rjhst.asl, line 7, characters 23 to 36:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rjvtr.asl
  File Rjvtr.asl, line 6, characters 22 to 39:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rrxqb.asl
  File Rrxqb.asl, line 6, characters 22 to 39:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rzyvw.asl
  File Rzyvw.asl, line 7, characters 22 to 39:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Ikfyg.asl
  File Ikfyg.asl, line 6, characters 13 to 14:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iydbr.asl
  File Iydbr.asl, line 7, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer {10}
  [1]

  $ aslref Rjqxc.asl
  File Rjqxc.asl, line 7, characters 8 to 23:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rkldr.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rlsvv.asl
  File Rlsvv.asl, line 16, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer {1..10}
  [1]

  $ aslref Rmhpw.asl
  File Rmhpw.asl, line 11, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rnpwr.asl
  File Rnpwr.asl, line 18, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rnzgh.asl

  $ aslref Rrqng.asl
  File Rrqng.asl, line 6, characters 8 to 9:
  ASL Typing error: cannot assign to immutable storage "x".
  [1]

  $ aslref Rssbd.asl
  File Rssbd.asl, line 12, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rwvqt.asl
  File Rwvqt.asl, line 8, characters 17 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rytnr.asl

  $ aslref Rzsnd.asl
  File Rzsnd.asl, line 10, characters 22 to 23:
  ASL Error: Cannot parse.
  [1]

  $ aslref Icgrh.asl

  $ aslref Itcst.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Iyjbb.asl

  $ aslref Ivqlx.asl

  $ aslref Rpzzj.asl

  $ aslref Rycpx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ibhln.asl
  File Ibhln.asl, line 8, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

  $ aslref Igjzq.asl

  $ aslref Igqrd.asl

  $ aslref Imkpr.asl
  File Imkpr.asl, line 27, characters 38 to 39:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iszvf.asl
  File Iszvf.asl, line 7, characters 22 to 23:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ixvbg.asl

  $ aslref Rgyjz.asl
  File Rgyjz.asl, line 6, characters 22 to 23:
  ASL Error: Cannot parse.
  [1]

  $ aslref Igqyg.asl
  File Igqyg.asl, line 5, characters 27 to 28:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rxnbn.asl

  $ aslref Xxswl.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Isbck.asl

  $ aslref Gmtxx.asl
  File Gmtxx.asl, line 6, characters 4 to 27:
  ASL Typing error: a subtype of integer {11} was expected,
    provided integer {0..10}.
  [1]

  $ aslref Ikjdr.asl

  $ aslref Dgwxk.asl

  $ aslref Dvmzx.asl

  $ aslref Dfxqv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dbmgm.asl
  File Dbmgm.asl, line 8, characters 17 to 18:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ikrll.asl

  $ aslref Rvbll.asl

  $ aslref Rwzvx.asl
  File Rwzvx.asl, line 6, characters 12 to 13:
  ASL Execution error: Mismatch type:
    value 4 does not belong to type integer {0..3}.
  [1]

  $ aslref Igysk.asl
  File Igysk.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ihswr.asl
  File Ihswr.asl, line 11, characters 4 to 15:
  ASL Typing error: a subtype of bits(4) was expected, provided bits(2).
  [1]

  $ aslref Iknxj.asl
  File Iknxj.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ikxsd.asl
  File Ikxsd.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Itwtz.asl
  File Itwtz.asl, line 6, characters 4 to 23:
  ASL Typing error: a subtype of bits(4) was expected, provided bits(2).
  [1]

  $ aslref Imhyb.asl

  $ aslref Isjdc.asl

  $ aslref Inlfd.asl

  $ aslref Rfmxk.asl

  $ aslref Dvpzz.asl

  $ aslref Ipqct.asl

  $ aslref Iwzkm.asl

  $ aslref Dbtbr.asl
  File Dbtbr.asl, line 11, character 0 to line 14, character 3:
  ASL Typing error: cannot declare already declared element "testa".
  [1]

  $ aslref Ifsfq.asl
  File Ifsfq.asl, line 11, character 0 to line 14, character 3:
  ASL Typing error: cannot declare already declared element "testa".
  [1]

  $ aslref Ipfgq.asl
  File Ipfgq.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

  $ aslref Isctb.asl
  File Isctb.asl, line 19, character 0 to line 22, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

  $ aslref Rpgfc.asl
  File Rpgfc.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "a".
  [1]

  $ aslref Dhbcp.asl

Output is non-deterministic
$ aslref Idfml.asl
Fatal error: exception Stack overflow
[2]

  $ aslref Ismmh.asl

  $ aslref Rfwqm.asl
  File Rfwqm.asl, line 3, characters 18 to 19:
  ASL Error: Undefined identifier: 'b'
  [1]

  $ aslref Rhwtv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rjbxq.asl
  File Rjbxq.asl, line 13, characters 16 to 17:
  ASL Error: Undefined identifier: 'b'
  [1]

  $ aslref Rschv.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rvdpc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ryspm.asl

  $ aslref Rftpk.asl

  $ aslref Rftvn.asl
  File Rftvn.asl, line 7, characters 10 to 12:
  ASL Typing error: a subtype of boolean was expected, provided integer {10}.
  [1]

  $ aslref Rjqyf.asl
  File Rjqyf.asl, line 5, characters 4 to 15:
  ASL Typing error: a subtype of boolean was expected, provided integer {10}.
  [1]

  $ aslref Rnbdj.asl
  File Rnbdj.asl, line 5, characters 7 to 9:
  ASL Typing error: a subtype of boolean was expected, provided integer {10}.
  [1]

  $ aslref Rnxrc.asl
  File Rnxrc.asl, line 5, characters 4 to 13:
  ASL Typing error: a subtype of exception {  } was expected,
    provided integer {10}.
  [1]

  $ aslref Rsdjk.asl
  File Rsdjk.asl, line 8, characters 13 to 15:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rvtjw.asl
  File Rvtjw.asl, line 5, character 4 to line 7, character 7:
  ASL Typing error: a subtype of integer was expected, provided real.
  [1]

  $ aslref Rwgsy.asl

  $ aslref Rwvxs.asl

  $ aslref Idgwj.asl
  File Idgwj.asl, line 9, characters 4 to 19:
  ASL Typing error: a subtype of b was expected, provided a.
  [1]

  $ aslref Ikkcc.asl

  $ aslref Immkf.asl
  File Immkf.asl, line 7, characters 4 to 5:
  ASL Typing error: a subtype of integer {0..N} was expected,
    provided integer {0..M}.
  [1]

  $ aslref Iyyqx.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rgnts.asl
  File Rgnts.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rlxqz.asl
  File Rlxqz.asl, line 5, characters 4 to 25:
  ASL Typing error: a subtype of integer was expected, provided real.
  [1]

  $ aslref Rwmfv.asl

  $ aslref Rzcvd.asl
  File Rzcvd.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iryrp.asl

  $ aslref Rzjky.asl

  $ aslref Djrxm.asl

  $ aslref Iztmq.asl

  $ aslref Iblvp.asl
  File Iblvp.asl, line 3, character 0 to line 6, character 3:
  ASL Typing error: cannot declare already declared element "N".
  [1]

  $ aslref Ibzvb.asl

  $ aslref Ilfjz.asl

  $ aslref Ipdkt.asl
  File Ipdkt.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Irkbv.asl
  File Irkbv.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Irqqb.asl

  $ aslref Itqgh.asl

  $ aslref Izlzc.asl

  $ aslref Rlvth.asl
  File Rlvth.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rrhtn.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rtjkq.asl
  File Rtjkq.asl, line 5, characters 4 to 39:
  ASL Typing error: a subtype of integer {32, 64} was expected,
    provided integer.
  [1]

  $ aslref Dcfyp.asl

  $ aslref Dljlw.asl

  $ aslref Dmfbc.asl

  $ aslref Dpmbl.asl

  $ aslref Dtrfw.asl

  $ aslref Dvxkm.asl

  $ aslref Ibtmt.asl
  File Ibtmt.asl, line 8, character 0 to line 11, character 3:
  ASL Typing error: cannot declare already declared element "test".
  [1]

  $ aslref Icmlp.asl

  $ aslref Iflkf.asl
  File Iflkf.asl, line 10, characters 4 to 20:
  ASL Typing error: a subtype of bits(2) was expected, provided bits(1).
  [1]

  $ aslref Iktjn.asl
  File Iktjn.asl, line 21, characters 4 to 6:
  ASL Typing error: a subtype of bits(N) was expected, provided bits(wid).
  [1]

  $ aslref Isbwr.asl
  File Isbwr.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Ivfdp.asl

  $ aslref Iymhx.asl

  $ aslref Rbqjg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rccvd.asl

  $ aslref Rkmbd.asl

  $ aslref Rmwbn.asl
  File Rmwbn.asl, line 3, characters 18 to 19:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rpfwq.asl

  $ aslref Rqybh.asl

  $ aslref Rrtcf.asl
  File Rrtcf.asl, line 10, characters 4 to 13:
  ASL Error: Arity error while calling 'test':
    0 arguments expected and 1 provided
  [1]

  $ aslref Rtcdl.asl

  $ aslref Rtzsp.asl
  File Rtzsp.asl, line 10, characters 4 to 12:
  ASL Error: Undefined identifier: 'test2'
  [1]

  $ aslref Rzlwd.asl

  $ aslref Rbknt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rjgwf.asl

  $ aslref Rttgq.asl
  File Rttgq.asl, line 10, characters 12 to 21:
  ASL Typing error: Illegal application of operator || on types a and integer
  [1]

  $ aslref Ivmzf.asl

  $ aslref Iyhml.asl
  File Iyhml.asl, line 5, characters 4 to 34:
  ASL Typing error: a subtype of integer {0..70} was expected,
    provided integer.
  [1]

  $ aslref Iyhrp.asl
  File Iyhrp.asl, line 5, characters 12 to 19:
  ASL Typing error: Illegal application of operator DIV on types integer {2, 4}
    and integer {(- 1)..1}
  [1]

  $ aslref Iyxsy.asl

  $ aslref Rbzkw.asl
  File Rbzkw.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rkfys.asl

  $ aslref Rzywy.asl

  $ aslref Ilghj.asl
  File Ilghj.asl, line 6, characters 18 to 20:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rkxmr.asl
  File Rkxmr.asl, line 6, characters 15 to 21:
  ASL Typing error: Illegal application of operator == on types bits(M)
    and bits(8)
  [1]

  $ aslref Rxzvt.asl

  $ aslref Rmrht.asl
  File Rmrht.asl, line 7, characters 12 to 18:
  ASL Typing error: Illegal application of operator == on types bits(1)
    and bits(11)
  [1]

  $ aslref Rsqxn.asl

  $ aslref Rkczs.asl

  $ aslref Rnynk.asl

  $ aslref Rfhyz.asl
  File Rfhyz.asl, line 3, characters 21 to 22:
  ASL Error: Cannot parse.
  [1]

  $ aslref Rvbmx.asl

  $ aslref Rxvwk.asl

  $ aslref Imjwm.asl

  $ aslref Ildnp.asl

  $ aslref Dcwvh.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dhlqc.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dyydw.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ilzcx.asl
  File Ilzcx.asl, line 4, characters 32 to 37:
  ASL Error: Undefined identifier: 'add'
  [1]

  $ aslref Ipkxk.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ilhlr.asl

  $ aslref Rrfqp.asl

  $ aslref Rvnkt.asl
  ASL Execution error: Illegal application of operator DIV for values 10 and 4.
  [1]

  $ aslref Dfxst.asl

  $ aslref Rwdgq.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Rzdkc.asl
  File Rzdkc.asl, line 3, characters 15 to 16:
  ASL Error: Cannot parse.
  [1]

  $ aslref Dccty.asl

  $ aslref Dcsft.asl

  $ aslref Ihybt.asl

  $ aslref Ilykd.asl

  $ aslref Inxjr.asl

  $ aslref Dkckx.asl

  $ aslref Dqnhm.asl

  $ aslref Imszt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Intyz.asl

  $ aslref Izpwm.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dzpmf.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ixykc.asl

  $ aslref Dxrbt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Ixsfy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Djljd.asl
  File Djljd.asl, line 3, characters 27 to 28:
  ASL Error: Cannot parse.
  [1]

  $ aslref Iwvgg.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Dmtqj.asl

  $ aslref Ikkqy.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  [1]

  $ aslref Iybgl.asl

  $ aslref Igfzt.asl 2>&1 | sed 's/File .*asllib/File asllib/g' 1>&2 && false
  File Igfzt.asl, line 21, characters 13 to 28:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Iqjtn_a.asl

  $ aslref Iqjtn_b.asl

  $ aslref Iqjtn_c.asl
  Uncaught exception: exc {err_code: 0}
  [1]

  $ aslref Iqjtn_d.asl
  Uncaught exception: exc {err_code: 0}
  [1]

  $ aslref Iqrxp.asl
  File Iqrxp.asl, line 10, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rxkgc.asl

  $ aslref Rgqnl.asl
  File Rgqnl.asl, line 21, characters 4 to 21:
  ASL Error: Undefined identifier: 'println'
  [1]

  $ aslref Rlrhd.asl
  File Rlrhd.asl, line 10, characters 13 to 23:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Rbncy.asl
  File Rbncy.asl, line 7, characters 17 to 32:
  ASL Error: Undefined identifier: 'exp_real'
  [1]

  $ aslref Inbct.asl

  $ aslref Rcrqj.asl
  File Rcrqj.asl, line 6, characters 21 to 35:
  ASL Error: Undefined identifier: 'div_int'
  [1]

  $ aslref Rghxr_a.asl
  File Rghxr_a.asl, line 7, characters 18 to 32:
  ASL Error: Undefined identifier: 'frem_int'
  [1]

  $ aslref Rghxr_b.asl
  File Rghxr_b.asl, line 5, characters 18 to 33:
  ASL Error: Undefined identifier: 'frem_int'
  [1]

  $ aslref Rncwm.asl
  File Rncwm.asl, line 7, characters 17 to 31:
  ASL Error: Undefined identifier: 'exp_int'
  [1]

  $ aslref Rsvmm.asl
  File Rsvmm.asl, line 7, characters 18 to 32:
  ASL Error: Undefined identifier: 'fdiv_int'
  [1]

  $ aslref Rthsv.asl
  File Rthsv.asl, line 6, characters 17 to 39:
  ASL Error: Undefined identifier: 'shiftleft_int'
  [1]

  $ aslref Rvgzf.asl
  File Rvgzf.asl, line 9, characters 17 to 37:
  ASL Error: Undefined identifier: 'shiftleft_int'
  [1]

  $ aslref Rwwtv_a.asl
  File Rwwtv_a.asl, line 5, characters 18 to 32:
  ASL Error: Undefined identifier: 'div_int'
  [1]

  $ aslref Rwwtv_b.asl
  File Rwwtv_b.asl, line 5, characters 18 to 32:
  ASL Error: Undefined identifier: 'fdiv_int'
  [1]

  $ aslref Rztjn_a.asl
  File Rztjn_a.asl, line 7, characters 18 to 31:
  ASL Error: Undefined identifier: 'div_int'
  [1]

  $ aslref Rztjn_b.asl
  File Rztjn_b.asl, line 5, characters 18 to 31:
  ASL Error: Undefined identifier: 'div_int'
  [1]

  $ aslref Rbrcm.asl
  File Rbrcm.asl, line 8, characters 13 to 19:
  ASL Typing error: Illegal application of operator + on types string
    and boolean
  [1]

  $ aslref Rrxyn.asl
  File Rrxyn.asl, line 9, characters 13 to 25:
  ASL Typing error: Illegal application of operator + on types string
    and integer
  [1]

  $ aslref Rdgbm.asl

