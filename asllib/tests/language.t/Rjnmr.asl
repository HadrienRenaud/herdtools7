// RUN: not interp %s | FileCheck %s

func a() => integer
begin
    println("error");
    return 10;
end

func main() => integer
begin
    constant b = a();
    return 0;
end
