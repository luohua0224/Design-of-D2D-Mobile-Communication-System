numNodes = 20;         % 节点数量
maxDistance = 100;     % 最大通信距离
sourceNode = 1;        % 源节点
destinationNode = 2;   % 目的节点
relayNodes = 3:numNodes;  % 中继节点
thresholdPower = 5;      % 门限功率
noisePower = 0.05;       % 噪声功率
transmitPower = 20;     % 初始转发功率
packetLossRate = zeros(1, numNodes); %用于储存每个节点的丢包率
receive_num=zeros(1,150);
nodePositions = maxDistance * rand(2, numNodes); % 生成节点位置
distances = pdist2(nodePositions', nodePositions'); % 计算节点之间的距离
% 初始化节点位置
scatter(nodePositions(1, :), nodePositions(2, :), 'filled');
% 构建随机移动的节点自组织网络
adjacencyMatrix = pdist2(nodePositions', nodePositions') <= maxDistance;
% 模拟节点移动和数据传输过程
for iteration = 1:150  
    nodePositions = nodePositions + randn(2, numNodes);
    scatter(nodePositions(1, :), nodePositions(2, :), 'filled');
    xlim([0, maxDistance]);
    ylim([0, maxDistance]);
    drawnow;
    pause(0.1);  
    % 数据传输过程
    for i = relayNodes
            % 节点无法直接与目的节点通信，尝试通过其他中继节点中继
            possibleRelays = find(adjacencyMatrix(i, :));
            selectedRelay = possibleRelays(randi(length(possibleRelays)));% 随机选择一个中继节点
            channelGain = 1 / distances(i, selectedRelay);
            receivedPower = transmitPower * channelGain;  % 计算接收信号功率
            %receivedPower = receivedPower + sqrt(noisePower) * randn();  % 添加高斯白噪声
            if receivedPower >thresholdPower  
                packetLossRate(i) = 0;
            end
            if receivedPower < thresholdPower 
                packetLossRate(i) = 1;
            end
    end
    P = packetLossRate;
    for i = 3 : numNodes
        P = P + packetLossRate.^i;
    end
    P(P ~= 0) = 1;
        receive_num(iteration)=P(1,numNodes);

end

lose_rate = 1-sum(receive_num)./150
disp("节点丢包率：");
disp(lose_rate);
