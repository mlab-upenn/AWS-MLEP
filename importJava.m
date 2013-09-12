import java.io.*;
import java.util.*;

% Import Jsch
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

% Import AWS
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.PropertiesCredentials;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.*;
import com.amazonaws.services.s3.*;
import com.amazonaws.services.simpledb.*;
import com.amazonaws.*;
import com.amazonaws.services.ec2.AmazonEC2Client;
import org.apache.http.client.methods.HttpUriRequest;