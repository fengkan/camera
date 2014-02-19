var job=angular.module('job',[]);

job.controller('jobId',function($scope,$http){
  $scope.query=function(){
    $http.post('/job/'+$scope.name+'.json','').success(function(data){
      $scope.results=data;
      $scope.currentId=data[0].id;
    });
  };
  $scope.ifStopLi=function(id){
    if(id==$scope.currentId)
      return ' stopli';
    else
      return '';
  };
});