pragma solidity 0.6.0;

contract MsgRecall {
    // 事件
    // 每次成功的上链记录，都会创建一个Recall事件
    // 可以通过txHash查询对应的事件
    event Recall(address from, address to, uint timestamp, bytes32 pk);


    // 用户授权的结构体, 表示from发起一次授权请求，删除和to的聊天记录
    // @from 表示发起地址
    // @pubkey pubkey of from 发起方的公钥地址
    // @to 表示对方地址
    // @type type 为0 表示to为个人； type 为1表示to为群
    // @timestamp 表示记录时间

    struct st {
        bytes32 pubkey;
        uint timestamp;
    }

    // to ==> mapping(from => timestamp)
    mapping (address => mapping (address => st)) Mapping;

    // 消息撤回记录上链接口，r,s,v表示用户授权签名
    function recall(address from, address to, uint timestamp, bytes32 pk, bytes32 s, byte v) public {
        // 验证from和pubkey是否一致

        // 验证用户授权的签名
        // address addr = ecrecoverDecode(from, to, timestamp, r, s, v);
        //if (addr != from) revert(); // 如果验签不通过，则回滚

        st memory sp;
        // sp.pubkey = pk;
        sp.timestamp = timestamp;
        // sp.t = t;
        // 记录from, to和timestamp
        Mapping[to][from] = sp;

        // 创建一个Recall事件，事件内容包含发起地址和对方地址
        emit Recall(from, to, timestamp, pk);
    }

    // 使用ecrecover恢复出公钥
    function ecrecoverDecode(address from, address to, uint timestamp, bytes32 r, bytes32 s, byte v) public  returns (address addr) {
        // 将from, to, timestamp拼接起来，做sha256，然后验签
        // sha256(bytes memory) returns (bytes32)
        // bytes32 hash = sha256(from, to, timestamp);
        // 从椭圆曲线签名中恢复与公钥相关的地址，或在出错时返回零。函数参数对应于签名的ECDSA值: r – 签名的前32字节; s: 签名的第二个32字节; v: 签名的最后一个字节
        // ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)
        // addr = ecrecover(hash, v, r, s);
    }

    // 查询接口
    function queryParams(address to, address from) public  returns (bytes32 pubkey, uint timestamp) {
        st memory s = Mapping[to][from];
        pubkey = s.pubkey;
        timestamp = s.timestamp;
    }
}
