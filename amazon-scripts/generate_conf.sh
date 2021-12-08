#!/bin/zsh

THIS_DIR=${0:A:h}
source $THIS_DIR/info.sh

{
cat <<EOF
<?xml version="1.0"?>
<!-- DOCTYPE ... -->

<configuration>
    <parameters>
        <param> 
            <name>protocol</name>
            <value>TCP</value>
        </param>
        <param>
            <name>timeout</name>
            <value>50</value>
        </param>
        <param>
            <name>group</name>
            <value>NIO</value>
        </param>
        <param>
            <name>bufferSize</name>
            <value>256</value>
        </param>
    </parameters>

    <peers>
EOF

for (( i = 1; i <= ${#IPS}; i++ )); do
cat <<EOF
        <replica> 
            <id>$((i - 1))</id> 
            <address>${IPS[$i]}</address> 
            <port>4444</port> 
        </replica>
EOF
done

cat <<EOF
    </peers>
</configuration>
EOF

} > $PSYNC_CONF

