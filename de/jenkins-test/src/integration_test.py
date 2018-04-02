#!/usr/bin/env python
import unittest
from rectangle import *
from square import *

class IntegrationTest(unittest.TestCase):
    ''' 
    def setUp(self):
        """ Setting up for the test """
        print "IntegrationTest:setUp_:begin"
        ## do something...
        print "IntegrationTest:setUp_:end"
    def tearDown(self):
        """Cleaning up after the test"""
        print "IntegrationTest:tearDown_:begin"
        ## do something...
        print "IntegrationTest:tearDown_:end"
    '''
    def testRectangleArea(self):
        self.assertEqual(getRectangleArea(3, 4), 12)
    def testiRectanglePerimeter(self):
        self.assertEqual(getRectanglePerimeter(3, 4), 14)
    def testSquareArea(self):
        self.assertEqual(getSquareArea(3), 9)
    def testSquarePerimeter(self):
        self.assertEqual(getSquarePerimeter(3), 12)
    result = unittest.TestResult()

if __name__ == '__main__':
    unittest.main()
