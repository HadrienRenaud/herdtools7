// RUN: interp %s | FileCheck %s
// CHECK: 3

func main() => integer
begin
    case '1010' of
        when '0000' => println("1");
        when '1000' => println("2");
        when '1010' => println("3");
        when '1111' => println("4");
        otherwise => pass;
    end
    return 0;
end
