function y = function_name(x) % 파일 이름이랑 이름이 같아야 한다.
  y = x^2;
endfunction;

function [y1, y2] = squareAndCubeThisNumber(x)
  y1 = x^2;
  y2 = x^2;
endfunction;

function J = costFunctionJ(X, y, theta)
  % X is the "design matrix" containing our training example
  % y is class labels
  m = size(X, 1);
  predictions = X*theta;
  sqrErrors = (predictions - y).^2;
  J = 1 / (2*m) * sum(sqrErrors);
endfunction;
