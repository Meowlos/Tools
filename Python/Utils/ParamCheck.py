# -*- coding:utf-8 -*-

import inspect
import functools

__all__ = ["param_check"]


def param_check(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        sig = inspect.signature(func)
        params = sig.parameters
        if len(params) == 0:
            return func()

        argspec = inspect.getfullargspec(func)

        # 位置参数与默认参数校验
        rlt = __val_type_check(func, argspec.args, params, *args, **kwargs)
        if not rlt[0]:
            raise ValueError("传入的参数不符合对应的类型注解, 参数: %s, 期望类型: %s, 传入类型: %s" % (rlt[1], rlt[2], rlt[3]))
        # 命名关键词校验
        rlt = __val_type_check(func, argspec.kwonlyargs, params, *args, **kwargs)
        if not rlt[0]:
            raise ValueError("传入的参数不符合对应的类型注解, 参数: %s, 期望类型: %s, 传入类型: %s" % (rlt[1], rlt[2], rlt[3]))

        return func(*args, **kwargs)

    return wrapper


def __val_type_check(func, arg_list, parameters, *args, **kwargs):
    for arg in arg_list:
        ann = parameters[arg].annotation
        if ann != inspect.Signature.empty:
            val = inspect.getcallargs(func, *args, **kwargs)[arg]
            if not isinstance(val, ann):
                return False, arg, ann, type(val),
    return True,
