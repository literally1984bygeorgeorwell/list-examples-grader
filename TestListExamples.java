import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

public class TestListExamples {
  @Test(timeout = 500)
  public void testMergeRightEnd() {
    List<String> left = Arrays.asList("a", "b", "c");
    List<String> right = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "a", "b", "c", "d");
    assertEquals(expected, merged);
  }

  @Test
  public void testFilter() {
    List<String> toFilter = Arrays.asList("sun", "moon", "gigachad", "mooning", "mooned", "Moon", "mOoN", "based and redpilled");
    StringChecker moonCheck = new IsMoon();
    // fuck it we ball
    //assertThrows("fuck it we ball", NoSuchMethodException.class, () -> {ListExamples.class.getMethod("filter", List.class, StringChecker.class);});
    /*try {
      ListExamples.class.getMethod("filter", List.class, StringChecker.class);
    }
    catch (Exception e) {
      fail();
      //System.out.println("fuck it we ball");
    }*/
    List<String> filtered = ListExamples.filter(toFilter, moonCheck);
    List<String> expected = Arrays.asList("moon", "Moon", "mOoN");
    assertEquals("filter should work dummy", expected, filtered); 
  }

  @Test
  public void testMergeDuplicates() {
    List<String> list1 = Arrays.asList("a", "b", "b", "c");
    List<String> list2 = Arrays.asList("b", "c", "d");
    List<String> expected = Arrays.asList("a", "b", "b", "b", "c", "c", "d");
    List<String> filtered = ListExamples.merge(list1, list2);
    assertEquals("merge should work dummy", expected, filtered);
  } 
}
