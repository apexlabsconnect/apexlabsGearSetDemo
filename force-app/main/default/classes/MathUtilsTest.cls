@IsTest
public with sharing class MathUtilsTest {
    @IsTest
    static void testSubtract() {
        Test.startTest();
        Integer result = MathUtils.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtract should return the difference between the two numbers.');
    }
}
