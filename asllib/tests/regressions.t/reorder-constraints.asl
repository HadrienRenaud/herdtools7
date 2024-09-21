func foo{N}(bv: bits(N))
begin
    var x : integer {0..N, 0, N};
    var y : integer {0, 0..N, N};
    x = y; // This fails
end
