function G.clone(xs)
  return { unpack(xs) }
end

function G.len(xs)
  if type(xs) ~= 'table' then
    return
  end

  local count = 0

  for _ in pairs(xs) do
    count = count + 1
  end

  return count
end

function G.first(xs)
  return xs[1]
end

function G.tail(xs)
  local ys = G.clone(xs)
  table.remove(ys, 1)

  return ys
end

function G.concat(xs, ys)
  local zs = G.clone(xs)

  if type(ys) == 'table' then
    for i in pairs(ys) do
      table.insert(zs, ys[i])
    end
  else
    table.insert(zs, ys)
  end

  return zs
end

function G.reduce(fn, acc, xs)
  if G.len(xs) == 0 then
    return acc
  end

  return G.reduce(fn, fn(acc, G.first(xs)), G.tail(xs))
end

function G.map(fn, xs)
  return G.reduce(function(acc, x)
    return G.concat(acc, fn(x))
  end, {}, xs)
end

function G.filter(fn, xs)
  return G.reduce(function(acc, x)
    return fn(x) and G.concat(acc, x) or acc
  end, {}, xs)
end

function G.all(fn, xs)
  return G.reduce(function(acc, x)
    return acc and fn(x)
  end, true, xs)
end

function G.any(fn, xs)
  return G.reduce(function(acc, x)
    return acc or fn(x)
  end, false, xs)
end
