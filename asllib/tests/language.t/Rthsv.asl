// RUN: not interp %s | FileCheck %s


func main() => integer
begin
    println("" + shiftleft_int(100, -3));
    return 0;
end
