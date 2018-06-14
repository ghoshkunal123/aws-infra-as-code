import unittest
import urllib
import urllib.request
import boto3 #pip3 install boto3
import os
import time
import datetime

def handler(event, context):

    unittest.TextTestRunner().run(
        unittest.TestLoader().loadTestsFromTestCase(SecurityTest))

class SecurityTest(unittest.TestCase):

    currentResult = None # holds last result object passed to run method

    @classmethod
    def setResult(cls, amount, errors, failures, skipped):
        cls.amount, cls.errors, cls.failures, cls.skipped = \
            amount, errors, failures, skipped

    @classmethod
    def tearDownClass(cls):
        print("\ntests run: " + str(cls.amount))
        print("errors: " + str(len(cls.errors)))
        print("failures: " + str(len(cls.failures)))
        print("success: " + str(cls.amount - len(cls.errors) - len(cls.failures)))
        print("skipped: " + str(len(cls.skipped)))
        
        sns_topic_arn = os.environ['sns_topic_arn']
        if len(cls.errors) > 0 or len(cls.failures) > 0:
            print ("Test failure! Notifying sns now")
            sns = boto3.client('sns')
            sns.publish(TopicArn=sns_topic_arn, Message='Tests of monitor dataeng fail ' )

    def run(self, result=None):
        self.currentResult = result # remember result for use in tearDown
        unittest.TestCase.run(self, result) # call superclass run method

    def setUp(self):
        print ("Start method %s" % (self._testMethodName))
         
    def tearDown(self):         
        amount = self.currentResult.testsRun
        errors = self.currentResult.errors
        failures = self.currentResult.failures
        skipped = self.currentResult.skipped
        self.setResult(amount, errors, failures, skipped)

        print ("Complete method %s" % (self._testMethodName))

    def test_https_airflow_accessable(self):
         url = os.environ['airflow_url']
         status_code = urllib.request.urlopen(url).getcode()
         print ("access %s: status_code = %s" % (url, status_code))
         self.assertTrue(status_code < 400)

    def test_https_flower_accessable(self):
         url = os.environ['flower_url']
         status_code = urllib.request.urlopen(url).getcode()
         print ("access %s: status_code = %s" % (url, status_code))
         self.assertTrue(status_code < 400)

    def test_s3_object_encrypt(self):
        s3 = boto3.resource('s3')
        s3_bucket_name = os.environ['s3_bucket']
        bucket = s3.Bucket(s3_bucket_name)
        for obj in bucket.objects.all():
            key = s3.Object(bucket.name, obj.key)
            if key.server_side_encryption not in ["AES256", "aws:kms"]:
                print ("Key:%s, keySSE:%s" % (key, key.server_side_encryption)) 
                self.assertTrue(False)
        self.assertTrue(True)

    def test_s3_bucket_encrypt(self):
        # Create an S3 client
        s3 = boto3.client('s3')
        s3_bucket_name = os.environ['s3_bucket']
        result = s3.get_bucket_encryption(Bucket=s3_bucket_name)
        print (result)
        encrypt = result['ServerSideEncryptionConfiguration']['Rules'][0]['ApplyServerSideEncryptionByDefault']['SSEAlgorithm']
        self.assertTrue(encrypt == "AES256")

    def check_bucket_grant(self, grant_permission, bucket_name):
        granted_warning = 'The following permission: :(:*{}*:): has been granted on the bucket *{}*'
        if grant_permission == 'read':
            return granted_warning.format('Read - Public Access: List Objects', bucket_name), True
        elif grant_permission == 'write':
            return granted_warning.format('Write - Public Access: Write Objects', bucket_name), True
        elif grant_permission == 'read_acp':
            return granted_warning.format('Write - Public Access: Read Bucket Permissions', bucket_name), True
        elif grant_permission == 'write_acp':
            return granted_warning.format('Write - Public Access: Write Bucket Permissions', bucket_name), True
        elif grant_permission == 'full_control':
            return granted_warning.format('Public Access: Full Control', bucket_name), True
        return '', False

    def test_s3_public_access(self):
        s3 = boto3.resource('s3')
        s3_bucket_name = os.environ['s3_bucket']
        bucket = s3.Bucket(s3_bucket_name)
        print(bucket.name)
        acl = bucket.Acl()
        for grant in acl.grants:
            print (grant)
            if grant['Grantee']['Type'].lower() == 'group' \
                and (grant['Grantee']['URI'] == 'http://acs.amazonaws.com/groups/global/AllUsers' \
                or grant['Grantee']['URI'] == 'http://acs.amazonaws.com/groups/global/AuthenticatedUsers'):
                text_to_post, send_warning = self.check_bucket_grant(grant['Permission'].lower(), bucket.name)

                if send_warning:            
                    print (text_to_post)
                    self.assertTrue(False)

        self.assertTrue(True)

    def test_redshift_public_access(self):
       rs = boto3.client("redshift")
       rs_cluster_id = os.environ['redshift_clusterid'] 
       response = rs.describe_clusters(ClusterIdentifier=rs_cluster_id)
       isPublic = response['Clusters'][0]['PubliclyAccessible']
       self.assertFalse(isPublic) 

    def test_redshift_encrypt(self):
       rs = boto3.client("redshift")
       rs_cluster_id = os.environ['redshift_clusterid']
       response = rs.describe_clusters(ClusterIdentifier=rs_cluster_id)
       isEncrypted = response['Clusters'][0]['Encrypted']
       self.assertTrue(isEncrypted)
       
if __name__ == '__main__':
    test = {}
    handler(test, None)
