// RUN: not interp %s | FileCheck %s

func main() => integer
begin
    println("" ++ div_int(6, 2));
    return 0;
end
