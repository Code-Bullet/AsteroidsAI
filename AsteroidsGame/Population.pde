class Population {
  Player[] players;//all dem players
  int bestPlayerNo;//the position in the array that the best player of this generation is in
  int gen = 0;
  Player bestPlayer;//the best ever player 
  int bestScore =0;//the score of the best ever player

  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Population(int size) {
    players = new Player[size];
    for (int i =0; i<players.length; i++) {
      players[i] = new Player();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //update all the players which are alive
  void updateAlive() {

    for (int i = 0; i< players.length; i++) {
      if (!players[i].dead) {
        players[i].look();//get inputs for brain 
        players[i].think();//use outputs from neural network
        players[i].update();//move the player according to the outputs from the neural network
        if (!showBest || i ==0) {//dont show dead players
          players[i].show();
        }
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //sets the best player globally and for this gen
  void setBestPlayer() {
    //get max fitness
    float max =0;
    int maxIndex = 0;
    for (int i =0; i<players.length; i++) {
      if (players[i].fitness > max) {
        max = players[i].fitness;
        maxIndex = i;
      }
    }

    bestPlayerNo = maxIndex;
    //if best this gen is better than the global best score then set the global best as the best this gen

    if (players[bestPlayerNo].score > bestScore) {
      bestScore = players[bestPlayerNo].score;
      bestPlayer = players[bestPlayerNo].cloneForReplay();
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //returns true if all the players are dead      sad
  boolean done() {
    for (int i = 0; i< players.length; i++) {
      if (!players[i].dead) {
        return false;
      }
    }
    return true;
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //creates the next generation of players by natural selection

  void naturalSelection() {


    Player[] newPlayers = new Player[players.length];//Create new players array for the next generation

    setBestPlayer();//set which player is the best

    newPlayers[0] = players[bestPlayerNo].cloneForReplay();//add the best player of this generation to the next generation without mutation
    for (int i = 1; i<players.length; i++) {
      //for each remaining spot in the next generation
      if (i<players.length/2) {
        newPlayers[i] = selectPlayer().clone();//select a random player(based on fitness) and clone it
      } else {
        newPlayers[i] = selectPlayer().crossover(selectPlayer());
      }
      newPlayers[i].mutate(); //mutate it
    }

    players = newPlayers.clone();
    gen+=1;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //chooses player from the population to return randomly(considering fitness)


  Player selectPlayer() {
    //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
    //then go through all the players and add their fitness to a running sum and if that sum is greater than the random value generated that player is chosen
    //since players with a higher fitness function add more to the running sum then they have a higher chance of being chosen


    //calculate the sum of all the fitnesses
    long fitnessSum = 0;
    for (int i =0; i<players.length; i++) {
      fitnessSum += players[i].fitness;
    }
    int rand = floor(random(fitnessSum));
    //summy is the current fitness sum
    int runningSum = 0;

    for (int i = 0; i< players.length; i++) {
      runningSum += players[i].fitness; 
      if (runningSum > rand) {
        return players[i];
      }
    }
    //unreachable code to make the parser happy
    return players[0];
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  //mutates all the players
  void mutate() {
    for (int i =1; i<players.length; i++) {
      players[i].mutate();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  
  //calculates the fitness of all of the players
  void calculateFitness() {
    for (int i =1; i<players.length; i++) {
      players[i].calculateFitness();
    }
  }
}