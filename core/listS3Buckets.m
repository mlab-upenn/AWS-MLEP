function [] = listS3Buckets(amazonS3Client)

disp('Listing Buckets');
listBuckets = amazonS3Client.listBuckets();


end
