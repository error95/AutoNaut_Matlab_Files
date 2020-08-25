function [xBest,xBestVal] = boolean_PSO_full(myFun,inputs,nParticles, maxIter) 
    x0 = randi([0 1], inputs,nParticles);
    x = zeros(inputs,nParticles,maxIter);
    v = zeros(inputs,nParticles);
    x(:,:,1) = x0;
    pBest = zeros(inputs,nParticles);
    pBestVal = 999*ones(1,nParticles);

    paramTresh = [0.5; 0.5; 0.5; 0.9; 0.9];

    fVal = inf(1,nParticles);
    for i = 1:nParticles
        fVal(i) = myFun(x(:,i,1));
    end
    newVal = (fVal<pBestVal);
    pBestVal = newVal.*fVal + pBestVal.*(~newVal);
    pBest = newVal.*x(:,:,1) + pBest.*(~newVal);
    [gBestVal,gBestPos] = min(pBestVal);
    gBest = repmat(x(:,gBestPos,1),1,nParticles);
    gBestVal

   for j = 1:(maxIter-1)
        omega = (rand(inputs,nParticles)>paramTresh(1));
        c1 = (rand(inputs,nParticles)>paramTresh(2));
        c2 = (rand(inputs,nParticles)>paramTresh(3));
        c3 = (rand(1)>paramTresh(4));
        random = (rand(inputs,nParticles)>paramTresh(5));
        v = (omega&v)|(c1&xor(pBest,x(:,:,j)))|(c2&xor(gBest,x(:,:,j)))|(c3&random);
        next = xor(x(:,:,j),v);
        x(:,:,j+1) = next;
       
       
        for i = 1:nParticles
            fVal(i) = myFun(x(:,i,j+1));
        end
        newVal = (fVal<pBestVal);
        pBestVal = newVal.*fVal + pBestVal.*(~newVal);
        pBest = newVal.*x(:,:,j+1) + pBest.*(~newVal);
        
        [tempGBestVal,tempGBestPos] = min(pBestVal);
        if tempGBestVal < gBestVal
            gBestVal = tempGBestVal;
            gBest = repmat(x(:,tempGBestPos,j+1),1,nParticles);
        end
   end
       
   xBest = pBest(:,tempGBestPos);
   xBestVal = gBestVal; 
end

