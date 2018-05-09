#!/usr/bin/env python
import sys
import unittest

class IntegrationTest(unittest.TestCase):
    def testCICD(self):
        self.assertTrue(False)
    result = unittest.TestResult()

if __name__ == '__main__':
    unittest.main()
