  function predictParticles = trackPeopleStateTransition(pf, prevParticles, t1, t2)

      
       % Position
       predictParticles(:,1) = prevParticles(:,1) + (t2-t1)*prevParticles(:,4);
       predictParticles(:,2) = prevParticles(:,2) + (t2-t1)*prevParticles(:,5);
       predictParticles(:,3) = prevParticles(:,3) + (t2-t1)*prevParticles(:,6);
       % velocity
       predictParticles(:,4) = prevParticles(:,4);
       predictParticles(:,5) = prevParticles(:,5);
       predictParticles(:,6) = prevParticles(:,6);
       


   end