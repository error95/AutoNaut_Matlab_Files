function [xBest,xBestVal] = continious_PSO(myFun,inputs,nParticles, maxIter, seed) 
    x0 = repmat(seed,1,nParticles) + 0.05*[randn(inputs,nParticles-1),zeros(inputs,1)];
    x = zeros(inputs,nParticles);
    v = zeros(inputs,nParticles);
    x = x0;
    pBest = zeros(inputs,nParticles);
    pBestVal = 99*ones(maxIter,nParticles);
    paramTresh = [0.1; 0.2; 0.5; 0.1; 0.5];

    fVal = inf(1,nParticles);
    for i = 1:nParticles
        fVal(i) = myFun(x(:,i));
    end
    newVal = (fVal<pBestVal(1,:));
    pBestVal(1,:) = newVal.*fVal + pBestVal(1,:).*(~newVal);
    pBest = newVal.*x + pBest.*(~newVal);
    [gBestVal,gBestPos] = min(pBestVal(1,:));
    gBest = repmat(x(:,gBestPos),1,nParticles);
    gBestVal

   for j = 1:(maxIter-1)
        omega = paramTresh(1);
        c1 = paramTresh(2);
        c2 = paramTresh(3);
        c3 = paramTresh(4);
        random = paramTresh(5)*randn(inputs,nParticles);
        v = omega*v + c1*(pBest-x) + c2*(gBest-x) + c3*random;
        x = x + v;
        
       
       
        for i = 1:nParticles
            fVal(i) = myFun(x(:,i));
        end
        newVal = (fVal<pBestVal(j,:));
        pBestVal(j+1,:) = newVal.*fVal + pBestVal(j,:).*(~newVal);
        pBest = newVal.*x + pBest.*(~newVal);
        
        [tempGBestVal,tempGBestPos] = min(pBestVal(j+1,:));
        if tempGBestVal < gBestVal
            gBestVal = tempGBestVal;
            gBest = repmat(x(:,tempGBestPos),1,nParticles);
        end
   end
       
   xBest = pBest(:,tempGBestPos);
   xBestVal = pBestVal; 
end


