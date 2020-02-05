pragma solidity 0.6.0;

contract Demo {
    // 事件
    // 每次成功的上链记录，都会创建一个Recall事件
    // 可以通过txHash查询对应的事件
    event Recall(address from, address to);


    // 用户授权的结构体, 表示from发起一次授权请求，删除和to的聊天记录
    // @from 表示发起地址
    // @to 表示对方地址
    // @timestamp 表示记录时间
    struct params {
        address from;
        address to;
        uint timestamp;
    }

    // to ==> mappint(from => to)
    mapping (address => mapping (address => params)) Mapping;


    // 消息撤回记录上链接口，r,s,v表示用户授权签名
    function recall(address from, address to, uint timestamp) public {
        // 验证用户授权的签名
        //address addr = ecrecoverDecode(from, to, timestamp, r,s,v);
        //if (addr != from) revert(); // 如果验签不通过，则回滚

        params memory p;
        p.from = from;
        p.to = to;
        p.timestamp = timestamp;

        Mapping[to][from] = p;

        // 创建一个Recall事件，事件内容包含发起地址和对方地址
        emit Recall(from, to);
    }

    // 使用ecrecover恢复出公钥
    function ecrecoverDecode(address from, address to, uint timestamp, bytes32 r, bytes32 s, byte v) public  returns (address addr) {
        // addr=ecrecover(hex(serializea(st)), v, r, s);
        addr = 0x0000000000000000000000000000000000000001;
    }

    // 查询接口
    function queryparams(address to, address from) public  returns (uint timestamp) {
        params memory p = Mapping[to][from];
        timestamp = p.timestamp;
    }
}
