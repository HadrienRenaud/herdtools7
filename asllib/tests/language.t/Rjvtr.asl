// RUN: not interp %s | FileCheck %s

func main() => integer
begin
    case TRUE of
        when FALSE => println("FALSE");
    end
    return 0;
end
