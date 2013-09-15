function [] = createS3Client(credPath)

%credProvider = com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider(java.lang.String(credPath));
propCred = com.amazonaws.auth.PropertiesCredentials(java.io.File(credPath))
basicCred = com.amazonaws.auth.BasicAWSCredentials(propCred.getAWSAccessKeyId,propCred.getAWSSecretKey);

amazonS3Client = com.amazonaws.services.s3.AmazonS3Client(basicCred);
listB = amazonS3Client.listBuckets;

end