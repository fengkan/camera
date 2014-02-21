angular.module('job',[]).controller('jobId',function($scope,$http){
  $scope.queryStatus={text:''};
  $scope.recommendations=[{name:'ccc'},{name:'777'}];
  $scope.queriedName=$scope.recommendations[Math.floor($scope.recommendations.length*Math.random())].name;
  $scope.nameOnKeyup=function(key){
    if(key==13)
      $scope.queriedName=$scope.name;
  }
  $scope.$watch('queriedName',function(){
    $http.get('/job/'+$scope.queriedName+'.json','').success(function(data){
      $scope.currentObj=data[0];
      $scope.queryStatus.text=$scope.currentObj.name+' 的3D照片：';
    }).error(function(data){
      if($scope.name)
        $scope.queryStatus.text='找不到'+$scope.name+' 的3D照片！';
      else
        $scope.queryStatus.text='';
    });
  });
  $scope.$watch('currentObj',function(){
    if(model)
      scene.remove(model);
    if(!$scope.currentObj)
      return;
    var newId=$scope.currentObj.name;
    var loader = new THREE.OBJMTLLoader();
    loader.load( '/obj/'+newId+'/'+newId+'.obj', '/obj/'+newId+'/'+newId+'.mtl', function ( object ) {
      model=object;
      scene.add( model );
    },true );
  });
  $scope.ifStopLi=function(name){
    if(!$scope.currentObj)
      return '';
    if(name==$scope.currentObj.name)
      return ' stopli';
    else
      return '';
  };
  $scope.randomRecommendation=function(){
    $scope.queriedName=$scope.recommendations[$scope.recommendations.length*Math.random()].name;
  };
});