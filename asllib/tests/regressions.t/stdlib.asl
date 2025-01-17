func test_uint {N} (bv: bits(N))
begin
  for i = 0 to 1 << N do
    assert UInt (i[N:0]) == i;
  end;
end;

func test_sint {N} (bv: bits(N))
begin
  for i = 0 to 1 << N  - 1 do
    assert SInt (i[N:0]) == i;
    assert SInt ('1' :: i[N-1:0]) == i - 1 << N;
  end;
end;

func check_pow2 (n: integer)
begin
  if n <= 1 then // For n <= 1, we can't test 'around' 2^n
    assert    IsPow2(0) == FALSE;
    assert  CeilPow2(0) == 1;
    // No FloorPow2 for 0

    assert    IsPow2(1) == TRUE;
    assert  CeilPow2(1) == 1;
    assert FloorPow2(1) == 1;

    assert    IsPow2(2) == TRUE;
    assert  CeilPow2(2) == 2;
    assert FloorPow2(2) == 2;

    assert    IsPow2(3) == FALSE;
    assert  CeilPow2(3) == 4;
    assert FloorPow2(3) == 2;

    return;
  end;

  let p = 2 ^ n;

  assert FloorPow2(p-1) == p DIVRM 2;
  assert  CeilPow2(p-1) == p;
  assert    IsPow2(p-1) == FALSE;

  assert FloorPow2(p) == p;
  assert  CeilPow2(p) == p;
  assert    IsPow2(p) == TRUE;

  assert FloorPow2(p+1) == p;
  assert  CeilPow2(p+1) == 2 * p;
  assert    IsPow2(p+1) == FALSE;
end;

// Extra main
func main() => integer
begin
  assert Abs (-1) == 1;
  assert Abs (2) == 2;

  assert Min (2, 3) == 2;
  assert Max (2, 3) == 3;

  assert Min (2.3, 3.3) == 2.3;
  assert Max (2.3, 3.3) == 3.3;

  assert IsEven (2);
  assert IsEven (0);
  assert IsEven (-2);
  assert !(IsEven (1));
  assert !(IsEven (-1));
  assert IsOdd (1);
  assert IsOdd (-1);

  assert Replicate{6}('01') == '010101';

  assert Zeros{0} == '';
  assert Zeros{3} == '000';
  assert Zeros{8} == '00000000';

  assert Ones{0} == '';
  assert Ones{3} == '111';
  assert Ones{8} == '11111111';

  assert IsZero(Zeros{2});
  assert IsOnes(Ones{3});
  assert ! IsZero(Ones{3});
  assert ! IsOnes(Zeros{3});
  assert ! IsZero ('101');

  assert SignExtend{5}('100') == '11100';
  assert ZeroExtend{5}('100') == '00100';
  assert Extend{5}('100', TRUE) == '00100';
  assert Extend{5}('100', FALSE) == '11100';

  assert Len('') == 0;
  assert Len('1010') == 4;

  assert UInt('110') == 6;
  assert UInt('') == 0;
  assert UInt('100000000') == 0x100;

  assert SInt('110') == -2;
  assert SInt('010') == 2;
  assert SInt('111') == -1;
  assert SInt('000') == 0;
  assert SInt('0') == 0;
  assert SInt('1') == -1;
  assert SInt('') == 0;

  test_uint{0}(Zeros{0});
  test_uint{1}(Zeros{1});
  test_uint{2}(Zeros{2});
  test_uint{3}(Zeros{3});

  test_sint{0}(Zeros{0});
  test_sint{1}(Zeros{1});
  test_sint{2}(Zeros{2});
  test_sint{3}(Zeros{3});

  for n = 0 to 25 do
    assert Log2(2 ^ n) == n;
  end;

  assert ((1 << 1)  == 2);
  assert ((1 << 0)  == 1);
  assert (((-1) << 0) == -1);
  assert (((-1) << 1) == -2);

  for m = -100 to 100 do
    let q = Real (m);
    assert RoundUp (q) == m;
    assert RoundDown (q) == m;
    assert RoundTowardsZero (q) == m;
  end;

  for m = -100 to 100 do
    let q = Real (m) / 3.0;
    assert RoundDown (q) == m DIVRM 3;
  end;

  for a = -100 to 100 do
    for b = 1 to 5 do
      assert a MOD b + (a DIVRM b) * b == a;
      assert (b * a) DIV b == a;
      if a MOD b == 0 then assert b * (a DIV b) == a; end;
    end;
  end;

  for i = 1 to 100 do
    let x = Real(i);
    let expected_res = SqrtRounded(x, 1000);
    for p = 1 to 10 do
      let res = SqrtRounded(x, p);
      // +2 because of the rounding to odd?
      assert Abs(res - expected_res) / expected_res <= 2.0 ^ (-p+2);
    end;
  end;

  let b_000 = BitCount ('000');
  assert b_000 == 0;
  let b_101 = BitCount ('101');
  assert b_101 == 2;
  let b_010 = BitCount ('010');
  assert b_010 == 1;
  let b_ = BitCount ('');
  assert b_ == 0;

  let lowestsetbit_000 = LowestSetBit ('000');
  assert lowestsetbit_000 == 3;
  let lowestsetbit_101 = LowestSetBit ('101');
  assert lowestsetbit_101 == 0;
  let lowestsetbit_010 = LowestSetBit ('010');
  assert lowestsetbit_010 == 1;
  let lowestsetbit_ = LowestSetBit ('');
  assert lowestsetbit_ == 0;

  let highestsetbit_000 = HighestSetBit ('000');
  assert highestsetbit_000 == -1;
  let highestsetbit_101 = HighestSetBit ('101');
  assert highestsetbit_101 == 2;
  let highestsetbit_010 = HighestSetBit ('010');
  assert highestsetbit_010 == 1;
  let highestsetbit_ = HighestSetBit ('');
  assert highestsetbit_ == -1;

  for i = 1 to 1000 do
    let x = Real (i) / 100.0;
    assert (Abs(ILog2(x) + ILog2(1.0 / x)) < 2);
  end;

  for i = -10 to 10 do
    let x = 3.0 ^ i;
    let lgx = ILog2(x);
    assert (Abs(lgx + ILog2(1.0 / x)) < 2);
    if i >= 0 then
      assert Log2(3 ^ (i as integer)) == lgx;
    end;
  end;

  for i = 10 to 1000 do
    assert Log2(i DIVRM 10) == ILog2 (Real (i) / 10.0);
  end;

  for n = 0 to 10 do
    check_pow2(n);
    check_pow2(19*n+1);
  end;

  assert AlignDownP2('110111', 1) == '110110';
  assert AlignDownP2('110111', 2) == '110100';
  assert AlignDownP2('110111', 3) == '110000';
  assert AlignDownP2('110111', 4) == '110000';
  assert AlignDownP2('110111', 5) == '100000';
  assert AlignDownP2('110111', 6) == '000000';
  assert AlignDownP2('001000', 1) == '001000';
  assert AlignDownP2('001000', 2) == '001000';
  assert AlignDownP2('001000', 3) == '001000';
  assert AlignDownP2('001000', 4) == '000000';
  assert AlignDownP2('001000', 5) == '000000';
  assert AlignDownP2('001000', 6) == '000000';
  assert AlignUpP2('110111', 1) == '111000';
  assert AlignUpP2('110111', 2) == '111000';
  assert AlignUpP2('110111', 3) == '111000';
  assert AlignUpP2('110111', 4) == '000000';
  assert AlignUpP2('110111', 5) == '000000';
  assert AlignUpP2('110111', 6) == '000000';
  assert AlignUpP2('001000', 1) == '001000';
  assert AlignUpP2('001000', 2) == '001000';
  assert AlignUpP2('001000', 3) == '001000';
  assert AlignUpP2('001000', 4) == '010000';
  assert AlignUpP2('001000', 5) == '100000';
  assert AlignUpP2('001000', 6) == '000000';

  for N = 0 to 5 do
    let pN = 2 ^ N;
    for x = -pN to pN do
      for y = 0 to N do
        let bv = x[0+:N];
        let p = 2^y as integer {1..2^N};

        assert AlignUpP2(bv, y) == AlignUpP2(x, y)[0+:N];
        assert AlignDownP2(bv, y) == AlignDownP2(x, y)[0+:N];

        assert AlignUpP2(x, y) IN {x..x+p};
        assert AlignDownP2(x, y) IN {(x - p)..x};

        assert AlignUpSize(x, p) == AlignUpP2(x, y);
        assert AlignDownSize(x, p) == AlignDownP2(x, y);

        assert AlignUpSize(bv, p) == AlignUpP2(bv, y);
        assert AlignDownSize(bv, p) == AlignDownP2(bv, y);
      end;
    end;
  end;

  return 0;
end;

// RUN: archex.sh --eval=':set asl=1.0' --eval=':set +syntax:aslv1_colon_colon' --eval=':load %s' --eval='assert main() == 0;' | FileCheck %s

