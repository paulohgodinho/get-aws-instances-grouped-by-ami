# get-aws-instances-grouped-by-ami

Gets a list of AMIs being used by your instances on a selected region, displaying a list of AMIs and the instances using them.

## Requirements
Powershell 7.x - [Installing Powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4) <br> 
AWS CLI - [AWS Command Line Interface](https://aws.amazon.com/cli/) 

## Usage
### Directly
`./GetAMIUsageForCurrentAccount.ps1 -Region us-west-1`

### Using Docker
Powershell:<br>
`./RunWithDocker.ps1 -Region us-west-1`

Shell<br>
`./RunWithDocker.sh -Region us-west-1`

### Parameters
`-Region` AWS Region <br>
`-Verbose` Enable Verbose output 

## Sample Output
```
{
  "ami-09b9e43233476eb5a8e": {
    "ImageName": "null",
    "ImageDescription": "null",
    "ImageLocation": "738814430855/MY-CUSTOM-WINDOWS-AMI",
    "OwnerId": "738813630844",
    "InstanceIds": [
      "i-0c00e8uc0a5765baf"
    ]
  }, 
  "ami-0806d02d120fbe8c2": {
    "ImageName": "null",
    "ImageDescription": "null",
    "ImageLocation": "738814430855/UBUNTU-PRE-BACKED-WITH-TOOLS",
    "OwnerId": "738813630844",
    "InstanceIds": [
      "i-0f7e75d336c19ed5b",
      "i-0cd7bd3729cfdee15"
    ]
  }
}
```

## Sample Verbose Output
```
VERBOSE: [GetAMIUsageForCurrentAccount] Working in Region ca-central-1
VERBOSE: [DescribeInstancesInCurrentAccount] Calling 'aws ec2 describe-instances' - Region ca-central-1
VERBOSE: [DescribeInstancesInCurrentAccount] Fetching next page
VERBOSE: [DescribeInstancesInCurrentAccount] Fetching next page
VERBOSE: [DescribeInstancesInCurrentAccount] Finished Describe Instance Calls
VERBOSE: [DescribeInstancesInCurrentAccount] Total Instances: 128
VERBOSE: [GetAMIUsageForCurrentAccount]
Count Name
----- ----
   17 ami-8dae2de9
   15 ami-0ea5356345b93da
   13 ami-0fe799d28a1469fb3
   13 ami-030742a769297e0
   10 ami-0faae3f2eb2e83c04
    4 ami-073aa8c85ab0e68
    2 ami-0da38e6f9084a0b
VERBOSE: [DescribeAMIsByIdInCurrentAccount] Calling 'aws ec2 describe-images' with 56 Image Ids - Region ca-central-1
VERBOSE: [DescribeAMIsByIdInCurrentAccount] Total Images: 3
{
  "ami-09b9e43233476eb5a8e": {
    "ImageName": "null",
    "ImageDescription": "null",
    "ImageLocation": "738814430855/MY-CUSTOM-WINDOWS-AMI",
    "OwnerId": "738813630844",
    "InstanceIds": [
      "i-0c00e8uc0a5765baf"
    ]
  }, 
  [...]
}
```

## Design Decisions
### AWS Tools for Powershell
I did not use the AWS Tools for Powershell to avoid adding another dependency and to keep the AWS CLI calls grounded to what people see on a day-to-day basis in Shell and the official documentation. This way, the user experience of someone looking at the script may seem more familiar even if they are not versed in Powershell.

### Breaking into multiple scripts
It is clear to me that logic related to querying machines and AMIs can be used elsewhere in the future, this is why I made the decision to split this "simple" script into multiple others. Of course, it also adds to the readability and overall tidiness of the project.

## Commentary on Output Schema
I would suggest changing the output schema to mimic the AWS CLI outputs. The current output has ONE object with N other objects inside, this is a characteristic of an Array, this is why I would change this outer parent object to one. This could help in parsing and iterating over the elements of the JSON.

From
```
{
    { },
    { },
    [...]
}
```
To
```
[
    { },
    { },
    [...]
]
```
