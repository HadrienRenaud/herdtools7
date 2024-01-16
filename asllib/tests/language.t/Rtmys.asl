// RUN: interp %s | FileCheck %s
// CHECK: 3

func main() => integer
begin
    if FALSE then
        println("1");
    elsif FALSE then
        println("2");
    elsif TRUE then
        println("3");
    end
    return 0;
end
