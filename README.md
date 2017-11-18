# Summary

This project is a script file for generating AWS credentials for use with MFA to add to your .aws/credentials file.

## Requirements

- Bash version 4 (for Mac, see [Update bash to version 4 on OSX](https://apple.stackexchange.com/questions/193411/update-bash-to-version-4-0-on-osx))

## How to use

```{bash}
./create-aws-credentials-for-mfa.sh --existing-profile=your-existing-profile \
  --serial-number=GET_FROM_IAM \
  --mfa-profile=new-profile-name --output=text \
  --region=us-east-1 \ --token-code=CODE_FROM_MFA_DEVICE >> ~/.aws/credentials
```

then your `~/.aws/credentials` file should contain the following:

```

[test-mfa-profile]
output=text
region=us-east-1
aws_access_key_id=YOUR_NEW_ACCESS_KEY_ID
aws_secret_access_key=YOUR_NEW_SECRED_ACCESS_KEY
aws_session_token=YOUR_NEW_SESSION_TOKEN
```

## References

[Arguments with flags](https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash-script)

[Get AWS credentials from command line](https://gist.github.com/ddgenome/f13f15dd01fb88538dd6fac8c7e73f8c)
