numNodes = 20;         % �ڵ�����
maxDistance = 100;     % ���ͨ�ž���
sourceNode = 1;        % Դ�ڵ�
destinationNode = 2;   % Ŀ�Ľڵ�
relayNodes = 3:numNodes;  % �м̽ڵ�
thresholdPower = 5;      % ���޹���
noisePower = 0.05;       % ��������
transmitPower = 20;     % ��ʼת������
packetLossRate = zeros(1, numNodes); %���ڴ���ÿ���ڵ�Ķ�����
receive_num=zeros(1,150);
nodePositions = maxDistance * rand(2, numNodes); % ���ɽڵ�λ��
distances = pdist2(nodePositions', nodePositions'); % ����ڵ�֮��ľ���
% ��ʼ���ڵ�λ��
scatter(nodePositions(1, :), nodePositions(2, :), 'filled');
% ��������ƶ��Ľڵ�����֯����
adjacencyMatrix = pdist2(nodePositions', nodePositions') <= maxDistance;
% ģ��ڵ��ƶ������ݴ������
for iteration = 1:150  
    nodePositions = nodePositions + randn(2, numNodes);
    scatter(nodePositions(1, :), nodePositions(2, :), 'filled');
    xlim([0, maxDistance]);
    ylim([0, maxDistance]);
    drawnow;
    pause(0.1);  
    % ���ݴ������
    for i = relayNodes
            % �ڵ��޷�ֱ����Ŀ�Ľڵ�ͨ�ţ�����ͨ�������м̽ڵ��м�
            possibleRelays = find(adjacencyMatrix(i, :));
            selectedRelay = possibleRelays(randi(length(possibleRelays)));% ���ѡ��һ���м̽ڵ�
            channelGain = 1 / distances(i, selectedRelay);
            receivedPower = transmitPower * channelGain;  % ��������źŹ���
            %receivedPower = receivedPower + sqrt(noisePower) * randn();  % ��Ӹ�˹������
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
disp("�ڵ㶪���ʣ�");
disp(lose_rate);
