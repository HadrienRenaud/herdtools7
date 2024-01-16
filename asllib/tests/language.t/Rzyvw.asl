// RUN: interp %s | FileCheck %s
// CHECK: Otherwise

func main() => integer
begin
    case TRUE of
        when FALSE => println("FALSE");
        otherwise => println("Otherwise");
    end
    return 0;
end
