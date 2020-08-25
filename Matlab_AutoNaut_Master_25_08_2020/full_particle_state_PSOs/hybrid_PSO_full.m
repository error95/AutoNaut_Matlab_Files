function [xBest,xBestVal] = hybrid_PSO_full(myFun,contInput,boolInput,nParticles, maxIter)
    inputs = contInput+boolInput;
    x0 = [randi([0 1], boolInput,nParticles);  1*randn(contInput,nParticles)];
    x = zeros(inputs,nParticles,maxIter);
    vb = zeros(boolInput,nParticles);
    v = zeros(contInput,nParticles);
    x(:,:,1) = x0;
    pBest = zeros(inputs,nParticles);
    pBestVal = 999*ones(1,nParticles);

    paramTreshCont = [0.5; 0.5; 0.5; 0.9; 0.5];
    paramTreshBool = [0.5; 0.5; 0.5; 0.9; 0.5];

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
       
       %Boolean PSO velocity step
        omegaB = (rand(boolInput,nParticles)>paramTreshBool(1));
        b1 = (rand(boolInput,nParticles)>paramTreshBool(2));
        b2 = (rand(boolInput,nParticles)>paramTreshBool(3));
        b3 = (rand(1)>paramTreshBool(4));
        random = (rand(boolInput,nParticles)>paramTreshBool(5));
        vb = (omegaB&vb)|(b1&xor(pBest(1:boolInput,:),x(1:boolInput,:,j)))|(b2&xor(gBest(1:boolInput,:),x(1:boolInput,:,j)))|(b3&random);
        next = xor(x(1:boolInput,:,j),vb);
        x(1:boolInput,:,j+1) = next;
       
       %Continious PSO velocity step
        omega = paramTreshCont(1);
        c1 = paramTreshCont(2);
        c2 = paramTreshCont(3);
        c3 = paramTreshCont(4);
        random = randn(contInput,nParticles);
        v = omega*v + c1*(pBest(boolInput+1:inputs,:)-x(boolInput+1:inputs,:,j)) + c2*(gBest(boolInput+1:inputs,:)-x(boolInput+1:inputs,:,j)) + c3*random;
        next = x(boolInput+1:inputs,:,j) + v;
        x(boolInput+1:inputs,:,j+1) = next;
        
       
       
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

