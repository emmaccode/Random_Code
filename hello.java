import org.python.util.PythonInterpreter;
import org.python;
public class helloworld {
  public static void main(String[] args) {
    try(PythonInterpreter pyInterp = new PythonInterpreter()) {
      pyInterp.exec("print('Hello World! Wait is this Python or Java')");
    }
  }
}
