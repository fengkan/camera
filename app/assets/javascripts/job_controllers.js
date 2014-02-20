var job=angular.module('job',[]);

job.controller('jobId',function($scope,$http){
  $scope.query=function(){
    $http.post('/job/'+$scope.name+'.json','').success(function(data){
      $scope.results=data;
      $scope.currentId=data[0].id;
    });
  };
  $scope.changeModel=function(newId){
    if(model)
      scene.remove(model);
    var loader = new THREE.OBJMTLLoader();
    loader.load( '/obj/'+newId+'/'+newId+'.obj', '/obj/'+newId+'/'+newId+'.mtl', function ( object ) {
      object.position.x = 0;
      object.position.y = 0;
      object.position.z = 0;
      object.rotation.x = 0;
      object.rotation.y = 0;
      object.rotation.z = -1.6;
      object.scale.x = 1;
      object.scale.y = 1;
      object.scale.z = 1;
      model=object;
      scene.add( model );
    } );
  }
  $scope.ifStopLi=function(id){
    if(id==$scope.currentId)
      return ' stopli';
    else
      return '';
  };
});