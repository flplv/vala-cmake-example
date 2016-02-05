public class MyClassTest : TestCase {

    MyClass cut ;

    public MyClassTest () {
        base ("my_class") ;
        add_test ("foo", test_foo) ;
    }

    public override void setup() {
        this.cut = new MyClass () ;
    }

    public override void teardown() {
    }

    public void test_foo() {
        this.cut.foo_silent () ;
        assert (this.cut.fooed == 1) ;
    }

}
