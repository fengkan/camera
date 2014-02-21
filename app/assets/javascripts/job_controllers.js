var job=angular.module('job',[]);

job.controller('jobId',function($scope,$http){
  $scope.queryStatus={text:''};
  $scope.recommendations=[{name:'ccc'},{name:'777'}];
  $scope.$watch('queriedName',function(){
    $http.post('/job/'+$scope.queriedName+'.json','').success(function(data){
      $scope.queryStatus.text=$scope.name+' 的3D照片：';
      $scope.results=data;
      $scope.currentId=$scope.queriedName;
    }).error(function(data){
      if($scope.name)
        $scope.queryStatus.text='找不到'+$scope.name+' 的3D照片！';
      else
        $scope.queryStatus.text='';
      $scope.results=undefined;
      $scope.randomRecommendation();
    });
  });
  $scope.$watch('currentId',function(){
    if(model)
      scene.remove(model);
    var newId=$scope.currentId;
    var loader = new THREE.OBJMTLLoader();
    loader.load( '/obj/'+newId+'/'+newId+'.obj', '/obj/'+newId+'/'+newId+'.mtl', function ( object ) {
      model=object;
      scene.add( model );
    } );
  });
  $scope.ifStopLi=function(name){
    if(name==$scope.currentId)
      return ' stopli';
    else
      return '';
  };
  $scope.randomRecommendation=function(){
    $scope.currentId=$scope.recommendations[$scope.recommendations.length*Math.random()];
    console.log($scope.currentId);
  };
});