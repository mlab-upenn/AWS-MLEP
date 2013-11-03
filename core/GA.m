clear;
clc;
%% Create COM object, Load Version
copyfile('C:\Users\Tao-mLab2\Downloads\UPenn\*.sig','C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\');
visum = actxserver('VISUM.Visum.120');
visum.LoadVersion('C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\newsub1.ver');
visum.LoadPathFile('C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\default_dir.pfd');


%% Create nodes object and its iterator, create map, set xml file writing format
nodes = visum.Net.Nodes;
nodeItr = nodes.Iterator;
scCount = 1;
mapNodeCoord = containers.Map('KeyType','uint32','ValueType','any');
mapNodeNo = containers.Map('KeyType','uint32','ValueType','any');
mapIterSignalRec = containers.Map('KeyType','uint32','ValueType','any');
mapIterDelayRec = containers.Map('KeyType','uint32','ValueType','any');

Pref.StructItem = false; %%set xml(.sig) file writing format

%% Pick out signalized intersections
while nodeItr.Valid
    curNode = nodeItr.Item;
    coord.x = curNode.AttValue('XCoord');
    coord.y = curNode.AttValue('YCoord');
    mapNodeCoord(curNode.AttValue('NO')) = coord;
%     curNode.AttValue('NO')
    if strcmp(curNode.AttValue('SCType'),'External')
        mapNodeNo(curNode.AttValue('NO')) = scCount;
        signalizedNodes(scCount) = curNode.AttValue('NO');
%         coord(scCount).x = curNode.AttValue('XCoord');
%         coord(scCount).y = curNode.AttValue('YCoord');
       
        scCount = scCount + 1;
    end       
    nodeItr.Next;
end
% mapNodeCoord = containers.Map(signalizedNodes, coord);
nodeItr.Reset;
scCount = 1;


%% Randomly create first generation
population = 100;
generation = 45;
expectedPerformance = 640;  % expected total delay at all intersections
signalcontrols = visum.Net.signalControls;
scItr = signalcontrols.Iterator;
allChromosome = zeros(generation,population,signalcontrols.Count);
delayRec = zeros(generation,population);
Cnt = 1;
while scItr.Valid
    curSC = scItr.Item;   
    scFileName =  strcat(visum.GetPath(35),curSC.AttValue('FILENAME'));
    [scxml{Cnt},root{Cnt},domnode{Cnt}] = xml_read(scFileName);
    scItr.Next;
    Cnt = Cnt + 1;
   
end
scItr.Reset;
for i = 1:population
    display([1 i]);
    copyfile('C:\Users\Tao-mLab2\Downloads\UPenn\*.sig','C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\');
    totalDelay = 0;
    Cnt = 1;
    CycleLengthOffset = randi(15,1,signalcontrols.Count);
    WEGreenTimeOffset = randi(15,1,signalcontrols.Count);   
    OffsetFactor = randi(4,1,signalcontrols.Count) - 1;
% %     chromo2Signal(signalizedNodes, CycleLengthOffset, WEGreenTimeOffset, OffsetFactor )
%     parfor j = 1:length(signalizedNodes)
%         curSC = signalcontrols.ItemByKey(signalizedNodes(j));
%         scFileName =  strcat(visum.GetPath(35),curSC.AttValue('FILENAME'));
%         chromo2Signal(scFileName, CycleLengthOffset, WEGreenTimeOffset, OffsetFactor, j, Pref);
% %         [scxml{Cnt},root{Cnt},domnode{Cnt}] = xml_read(scFileName);
% %         scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.cycletime = scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.cycletime + 1000 * (CycleLengthOffset(Cnt) - 8);
% %         scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin - 0.5 * 1000 * (8 - CycleLengthOffset(Cnt));     
% %         scxml{Cnt}.stageProgs.stageProg.interstages.interstage(2).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(2).ATTRIBUTE.begin - 1000 * (8 - CycleLengthOffset(Cnt));
% %         scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin + 1000 * (WEGreenTimeOffset(Cnt) - 8);  
% %         scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.offset = 15 * OffsetFactor(Cnt);
% %         xml_write(scFileName,scxml{Cnt},root{Cnt},Pref);
%     end
    while scItr.Valid
       curSC = scItr.Item;
       scFileName =  strcat(visum.GetPath(35),curSC.AttValue('FILENAME'));
%        [scxml{Cnt},root{Cnt},domnode{Cnt}] = xml_read(scFileName);
       new_scxml{Cnt} = scxml{Cnt};
       new_scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.cycletime = scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.cycletime + 1000 * (CycleLengthOffset(Cnt) - 8);
       new_scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin - 0.5 * 1000 * (8 - CycleLengthOffset(Cnt));     
       new_scxml{Cnt}.stageProgs.stageProg.interstages.interstage(2).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(2).ATTRIBUTE.begin - 1000 * (8 - CycleLengthOffset(Cnt));
       new_scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin + 1000 * (WEGreenTimeOffset(Cnt) - 8);  
       new_scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.offset = 15 * OffsetFactor(Cnt);
       xml_write(scFileName,new_scxml{Cnt},root{Cnt},Pref);
       
       scItr.Next;
       Cnt = Cnt + 1;
   
    end
    
    scItr.Reset;
    singleChromosome = strcat(dec2bin(CycleLengthOffset,4),dec2bin(WEGreenTimeOffset,4),dec2bin(OffsetFactor,2));
    allChromosome(1,i,:) = bin2dec(singleChromosome);
    visum.Procedures.Execute;
    for j = 1:nodes.count
        totalDelay = totalDelay + nodeItr.item.AttValue('LOSAvgDelay');
        nodeItr.Next;
    end
    curScheduleDelay = totalDelay

    nodeItr.Reset;
    delayRec(1,i) = totalDelay;    
    
end
fitness = getFitness(delayRec(1,:), expectedPerformance);
idxIndividualSelected = selection(fitness, population);
selectedIndividuals = allChromosome(1, idxIndividualSelected,:); 
recombined_chromosomes = recombination(selectedIndividuals);
newGeneration = mutation(recombined_chromosomes);
allChromosome(2,:,:) = newGeneration;
currentMinDelay = min(delayRec(1,:));
i = 2; %Current Gen
while i < generation && currentMinDelay > expectedPerformance
    for j = 1:population
        display([i j]);
        copyfile('C:\Users\Tao-mLab2\Downloads\UPenn\*.sig','C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\');
        totalDelay = 0;
        Cnt = 1;
        bitChromo = dec2bin(allChromosome(i,j,:),10);
        for z = 1:signalcontrols.count
            CycleLengthOffset(z) = bin2dec(bitChromo(z,1:4));
            WEGreenTimeOffset(z) = bin2dec(bitChromo(z,5:8));   
            OffsetFactor(z) = bin2dec(bitChromo(z,9:10));
            
        end
%         CycleLengthOffset = str2double(bitChromo(:,1:4));
%         WEGreenTimeOffset = str2double(bitChromo(:,5:8));   
%         OffsetFactor = str2double(bitChromo(:,9:10));
        while scItr.Valid
            curSC = scItr.Item;
            scFileName =  strcat(visum.GetPath(35),curSC.AttValue('FILENAME'));
            new_scxml{Cnt} = scxml{Cnt};
            new_scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.cycletime = scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.cycletime + 1000 * (CycleLengthOffset(Cnt) - 8);
            new_scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin - 0.5 * 1000 * (8 - CycleLengthOffset(Cnt));     
            new_scxml{Cnt}.stageProgs.stageProg.interstages.interstage(2).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(2).ATTRIBUTE.begin - 1000 * (8 - CycleLengthOffset(Cnt));
            new_scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin + 1000 * (WEGreenTimeOffset(Cnt) - 8);  
            new_scxml{Cnt}.stageProgs.stageProg.ATTRIBUTE.offset = 15 * OffsetFactor(Cnt);
            xml_write(scFileName,new_scxml{Cnt},root{Cnt},Pref);
            scItr.Next;
            Cnt = Cnt + 1;
        end
        scItr.Reset;
        visum.Procedures.Execute;
        for k = 1:nodes.count
            totalDelay = totalDelay + nodeItr.item.AttValue('LOSAvgDelay');
            nodeItr.Next;
        end
        nodeItr.Reset;
        curScheduleDelay = totalDelay
        delayRec(i,j) = totalDelay;    
 
    end
    fitness = getFitness(delayRec(i,:), expectedPerformance);
    idxIndividualSelected = selection(fitness, population);
    selectedIndividuals = allChromosome(i, idxIndividualSelected,:); 
    recombined_chromosomes = recombination(selectedIndividuals);
    newGeneration = mutation(recombined_chromosomes);
    if i+1 < generation
        allChromosome(i+1,:,:) = newGeneration;       
        currentDelayMin = min(delayRec(i,:));
        i = i + 1;
    end
    
end


% 
% 
% for i = 1:signalcontrols.Count
%    curSC = scItr.Item;
%    SignalGroups = curSC.SignalGroups;
%    SGSIter = SignalGroups.Iterator;
%  
%    SignalGroup1 = SGSIter.Item;
% %    SGSIter.Next;
% %    SignalGroup2 = SGSIter.Item;
%     
%    GreenTimeWE = dec2bin(SignalGroup1.AttValue('GtEnd') - SignalGroup1.AttValue('GtStart'));
%    cycleTime = curSC.AttValue('Cycletime');
%    offset = curSC.AttValue('TimeOffset');
%     
% end
% 
% 
% clear;
% clc;
% 
% %% Create COM object, Load Version
% copyfile('C:\Users\Tao-mLab2\Downloads\UPenn\*.sig','C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\');
% visum = actxserver('VISUM.Visum.120');
% visum.LoadVersion('C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\newsub1.ver');
% visum.LoadPathFile('C:\Users\Tao-mLab2\Downloads\UPenn\newsubCC\default_dir.pfd');
% visum.Procedures.Execute;
% 
% %% Create nodes object and its iterator, create map, set xml file writing format
% nodes = visum.Net.Nodes;
% nodeItr = nodes.Iterator;
% scCount = 1;
% mapNodeCoord = containers.Map('KeyType','uint32','ValueType','any');
% mapNodeNo = containers.Map('KeyType','uint32','ValueType','any');
% mapIterSignalRec = containers.Map('KeyType','uint32','ValueType','any');
% mapIterDelayRec = containers.Map('KeyType','uint32','ValueType','any');
% 
% Pref.StructItem = false; %%set xml(.sig) file writing format
% 
% %% Pick out signalized intersections
% while nodeItr.Valid
%     curNode = nodeItr.Item;
%     coord.x = curNode.AttValue('XCoord');
%     coord.y = curNode.AttValue('YCoord');
%     mapNodeCoord(curNode.AttValue('NO')) = coord;
% %     curNode.AttValue('NO')
%     if strcmp(curNode.AttValue('SCType'),'External')
%         mapNodeNo(curNode.AttValue('NO')) = scCount;
%         signalizedNodes(scCount) = curNode.AttValue('NO');
% %         coord(scCount).x = curNode.AttValue('XCoord');
% %         coord(scCount).y = curNode.AttValue('YCoord');
%        
%         scCount = scCount + 1;
%     end       
%     nodeItr.Next;
% end
% % mapNodeCoord = containers.Map(signalizedNodes, coord);
% nodeItr.Reset;
% scCount = 1;
% for iter = 1:1
% iter    
% links = visum.Net.Links;    
% turns = visum.Net.Turns;
% signalcontrols = visum.Net.signalControls;
% linkItr = links.Iterator;
% turnItr = turns.Iterator;
% scItr = signalcontrols.Iterator;
% mapNodeVolume = containers.Map('KeyType','uint32','ValueType','any');
% totalDelay = 0;
% 
% %% Get Traffic Volume at each signalized intersections
% while turnItr.Valid
%    curTurn = turnItr.Item;
%    if sum(curTurn.AttValue('ViaNodeNo') == signalizedNodes) ~= 0  && curTurn.AttValue('VolVehPrT(AP)') ~= 0
%        volume = zeros(12,2);
%        if ~mapNodeVolume.isKey(curTurn.AttValue('ViaNodeNo'))
%            mapNodeVolume(curTurn.AttValue('ViaNodeNo')) = volume;
%        
%        end
%        
%        actualVolume = curTurn.AttValue('VolVehPrT(AP)');
%        effectiveVolume = actualVolume / curTurn.AttValue('NumEffLanes');
%        switch curTurn.AttValue('Orientation')
%            case 'EBL'
%                volume(1,1) = actualVolume;
%                volume(1,2) = effectiveVolume;
%            case 'EBT'
%                volume(2,1) = actualVolume;
%                volume(2,2) = effectiveVolume;
%            case 'EBR'
%                volume(3,1) = actualVolume;
%                volume(3,2) = effectiveVolume;
%            case 'SBL'
%                volume(4,1) = actualVolume;
%                volume(4,2) = effectiveVolume;
%            case 'SBT'
%                volume(5,1) = actualVolume;
%                volume(5,2) = effectiveVolume;
%            case 'SBR'
%                volume(6,1) = actualVolume;
%                volume(6,2) = effectiveVolume;
%            case 'WBL'
%                volume(7,1) = actualVolume;
%                volume(7,2) = effectiveVolume;
%            case 'WBT'
%                volume(8,1) = actualVolume;
%                volume(8,2) = effectiveVolume;
%            case 'WBR'
%                volume(9,1) = actualVolume;
%                volume(9,2) = effectiveVolume;
%            case 'NBL'
%                volume(10,1) = actualVolume;
%                volume(10,2) = effectiveVolume;
%            case 'NBT'
%                volume(11,1) = actualVolume;
%                volume(11,2) = effectiveVolume;
%            case 'NBR'
%                volume(12,1) = actualVolume;
%                volume(12,2) = effectiveVolume;
%            otherwise
%                
%        end
%      
%        mapNodeVolume(curTurn.AttValue('ViaNodeNo')) = mapNodeVolume(curTurn.AttValue('ViaNodeNo')) + volume;
%        
%        
% %        curTurn.AttValue()
% %        abs(mapNodeCoord(curTurn.AttValue('FromNodeNo')).x - mapNodeCoord(curTurn.AttValue('ViaNodeNo')).x) > abs(mapNodeCoord(curTurn.AttValue('FromNodeNo')).y - mapNodeCoord(curTurn.AttValue('ViaNodeNo')).y)
% %        curTurn.AttValue('ViaNodeNo')
%     
%    end
%    turnItr.Next;
%     
% end
% turnItr.Reset;
% %%  Do something with link
% % while linkItr.Valid
% %    curLink = linkItr.Item;
% %    if strfind(curLink.AttValue('TSysSet'),'Car')
% %        
% %        
% %    end
% %    linkItr.Next 
% %     
% % end
% 
% %% Signal controller update
% SignalRec = zeros(mapNodeNo.Count,2);
% while scItr.Valid
%     curSC = scItr.Item;
%     scFileName =  strcat(visum.GetPath(35),curSC.AttValue('FILENAME'));
%     [scxml{Cnt},root{Cnt},domnode{Cnt}] = xml_read(scFileName);
%     maxVol = zeros(4,1);
%     curNodeVol = mapNodeVolume(scxml{Cnt} .ATTRIBUTE.id);
% 
%     maxEffVol(1) = max(curNodeVol(1:3,2));
%     maxEffVol(2) = max(curNodeVol(4:6,2));
%     maxEffVol(3) = max(curNodeVol(7:9,2));
%     maxEffVol(4) = max(curNodeVol(10:12,2));
%     
%     maxEWEffVol = max(maxEffVol(1),maxEffVol(3));
%     maxSNEffVol = max(maxEffVol(2),maxEffVol(4));
%     SignalRec(mapNodeNo(scxml{Cnt}.ATTRIBUTE.id),1) = scxml{Cnt}.ATTRIBUTE.id;
%     SignalRec(mapNodeNo(scxml{Cnt}.ATTRIBUTE.id),2) = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin;
% 
%     new_scxml = scxml{Cnt};
%     
% %     new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin + round(10 * sign(maxEWEffVol - maxSNEffVol)* round(100 * (maxEWEffVol/(maxEWEffVol+maxSNEffVol))));
% 
%   
%     new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin + 100 * sign(maxEWEffVol - maxSNEffVol);
% %     new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin + roundn(500 * sign(maxEWEffVol - maxSNEffVol) * abs(maxEWEffVol - maxSNEffVol)/(maxEWEffVol - maxSNEffVol),3);
%     %% Constrain of pedestrian
%     if new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin <= 16000
%         new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = 16000;
%     end
%     if new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin >= 32000
%         new_scxml.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin = 32000;
%     end
%     %%
%     xml_write(scFileName,new_scxml,root{Cnt},Pref);
%    scItr.Next ;
% end
% mapIterSignalRec(iter) = SignalRec;
% allSignalRec(iter) = scxml{Cnt}.stageProgs.stageProg.interstages.interstage(1).ATTRIBUTE.begin;
% scItr.Reset;
% visum.Procedures.Execute;
% for i = 1:nodes.count
%     totalDelay = totalDelay + nodeItr.item.AttValue('LOSAvgDelay');
%     nodeItr.Next;
% 
% end
% mapIterDelayRec(iter) = totalDelay;
% allDelayRec(iter) = totalDelay;
% nodeItr.Reset;
% end
